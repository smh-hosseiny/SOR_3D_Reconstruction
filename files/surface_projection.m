function [interp_rgb, status] = surface_projection(Image, R, n, Pbase, K, p1, lb, ub, ...
    dh, bot_point, ang, f, region_mask, symmetry_angle)
% SURFACE_PROJECTION Projects the surface texture onto a 3D model.
%
%   [interp_rgb, status] = SURFACE_PROJECTION(Image, R, n, Pbase, K, p1, lb, ub, ...
%       dh, bot_point, ang, f, region_mask, symmetry_angle)
%
%   This function computes the texture mapping for a 3D model by projecting
%   the 3D circles onto the 2D image and extracting the surface patterns.
%
%   Inputs:
%       Image           - Input RGB image of the object.
%       R               - Rotation matrix for aligning the object.
%       n               - Normal vector of the symmetry plane.
%       Pbase           - Base point in 3D space.
%       K               - Camera intrinsic matrix.
%       p1              - Initial projection point.
%       lb              - Lower bound index for depth.
%       ub              - Upper bound index for depth.
%       dh              - Height increment.
%       bot_point       - Bottom point coordinates of the object.
%       ang             - Angle for Main axis rotation (in degrees).
%       f               - Focal length of the camera.
%       region_mask     - Mask defining the region of interest in the image.
%       symmetry_angle  - Symmetry angle of the object (used for determining front side).
%
%   Outputs:
%       interp_rgb      - Interpolated RGB image after projection.
%       status          - Status flag (0 if successful, 1 if an error occurred).
%
%   Example:
%       [texture, status] = surface_projection(img, R, n, Pbase, K, p1, lb, ub, ...
%           dh, bot_point, ang, f, mask, symmetry_angle);



    % Initialize status flag
    status = 0;

    % Compute the adjusted normal vector na by rotating n around the axis perpendicular to n and [0;0;1]
    na = cross(n, [0; 0; 1]);
    na = na / norm(na);
    Rna = axang2rotm([n' ang * pi / 180]);
    na = Rna * na;

    % Initialize variables
    N = 32; % Number of sampling points
    rh = zeros(1, N); % Radii at different heights
    h = zeros(1, N);  % Heights
    a = n;
    b = cross(a, na);
    counter = 1;

    % Compute radii at different heights
    for i = linspace(lb, ub, N)
        center = Pbase + i * dh * na;
        radius = find_radius(K, p1, center, a, b, f, region_mask);
        h(counter) = i * dh;
        rh(counter) = radius;
        counter = counter + 1;
    end

    % Remove duplicate heights
    [~, idx] = unique(h);

    % Check if there are enough unique heights
    if length(idx) < 2
        interp_rgb = [];
        status = 1;
        return;
    end

    % Adjust height range if necessary
    if abs(min(h) - max(h)) < 0.01
        height = linspace(min(h), max(h) + rand(1) * 1e-1, 32);
    else
        height = linspace(min(h), max(h), 32);
    end

    % Interpolate radius values over the height range using spline
    cs = spline(h(idx), [0 rh(idx) 0]);
    radius = ppval(cs, height);

    %% Find the theta range for angular sampling
    size_ = 256; % Number of angular samples
    th = linspace(0, 360, 2 * size_); % Angles in degrees

    % Reshape image for processing
    Image_reshaped = reshape(Image, [], 1);
    surface_patterns = double(zeros(size(Image_reshaped)));

    % Determine front mask based on symmetry angle
    i = lb + 0.25 * (ub - lb);
    hq = i * dh;
    rq = interp1(height, radius, hq, 'linear');
    Points = Pbase + hq * na + rq * (a * cosd(th) + b * sind(th));
    qcircle = K * Points;
    qcircle = bsxfun(@rdivide, qcircle, qcircle(3, :));
    [~, idx] = min(vecnorm([qcircle(1, :); qcircle(2, :)] - bot_point'));
    if idx < size_ || symmetry_angle < 0
        front_angle = 1:size_;
    else
        front_angle = size_ + 1:2 * size_;
    end

    % Initialize counter
    cnt = 1;
    h = linspace(lb * dh, ub * dh, size_);
    for hq = h
        % Interpolate radius at current height
        rq = interp1(height, radius, hq, 'linear');
        % Compute points on the surface at current height and angle
        Points = Pbase + hq * na + rq * (a * cosd(th) + b * sind(th));
        qcircle = K * Points;
        qcircle = bsxfun(@rdivide, qcircle, qcircle(3, :));

        theta_indices = 1:size_;
        rotated_p = R' * qcircle(1:2, front_angle(theta_indices));
        q = rotated_p;

        % Get indices for image extraction
        y_ind = get_idx(q, 2, 1:length(theta_indices), size(Image, 1));
        x_ind = get_idx(q, 1, 1:length(theta_indices), size(Image, 2));

        lin = sub2ind(size(Image, [1, 2]), y_ind, x_ind);

        patterns_ = Image_reshaped(lin, :); % N x 3 matrix

        % Assign RGB values to surface patterns
        surface_patterns(lin, :) = patterns_;
        cnt = cnt + 1;
    end

    % Reshape surface patterns back to image size
    patterns = reshape(surface_patterns, size(Image));

    % Initialize output image
    interp_rgb = zeros(size(Image));
    new_img_channel = double(patterns);

    % Find non-zero coordinates in the new image channel
    [non_zero_vy, non_zero_vx] = find(new_img_channel > 0);
    Z = new_img_channel(new_img_channel > 0);

    % Find non-zero coordinates in the original image
    [non_zero_y, non_zero_x] = find(Image > 0);

    % Perform grid data interpolation to fill in missing values
    interpolated_values = griddata(non_zero_vx, non_zero_vy, Z, non_zero_x, non_zero_y, 'linear');
    interpolated_values = fillmissing(interpolated_values, 'nearest');

    % Assign interpolated values to output image
    linear_indices = sub2ind(size(interp_rgb), non_zero_y, non_zero_x);
    interp_rgb(linear_indices) = interpolated_values;
    interp_rgb = uint8(interp_rgb);

end