function [surface_patterns, profile] = fit_profile(Image,n, ang, Pbase, K,...
    p1, lb, ub, dh,f,bot_point,R,x_boundary,y_boundary, mask2,symmetry_angle)
   
    row = size(Image,1);
    col = size(Image,2);
    na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
    Rna = axang2rotm([n' ang*pi/180]);
    na = Rna*na;
    a = n;
    b = cross(a,na);
    % resolution of the reconstructed surface texture
    h = 384;
    w = 384;
    rh = nan(1, h);
    he = nan(1, h);

    th = linspace(0, 360, 2*w);
    counter = 1;

    % find angle range that captures surface patterns.
    % center = Pbase + lb*dh*na;
    % th0 = 0:60:360;
    % radius = find_radius(K, p1, center, a, b,f);
    % Points = center + radius*(a*cosd(th0)+b*sind(th0));
    % qcircle = K*Points;
    % qcircle = qcircle./repmat(qcircle(3,:),3,1);
    % [t, ~] = min(vecnorm([qcircle(1,:); qcircle(2,:)] - bot_point'));
    % if t < 180
    %     front_angle = 1:w;
    % else
    %     front_angle = w+1:2*w;
    % end
    
    surface_patterns = uint8(255 * ones(h,w,3));
   
    % fron mask
    i = lb + 0.25*(ub-lb);
    center = Pbase + i*dh*na;
    radius = find_radius(K, p1, center, a, b,f, mask2, 5000);
    Points = center + radius*(a*cosd(th)+b*sind(th));
    qcircle = K*Points;
    qcircle = qcircle./repmat(qcircle(3,:),3,1);

    [~, idx] = min(vecnorm([qcircle(1,:); qcircle(2,:)] - bot_point'));
    if idx < w || symmetry_angle < 0
        front_angle = 1:w;
    else
        front_angle = w+1:2*w;
    end

    
    %% generate circles
    for i = linspace(lb,ub,h)
        center = Pbase + i*dh*na;
        radius = find_radius(K, p1, center, a, b,f, mask2, 5000);
        Points = center + radius*(a*cosd(th)+b*sind(th));
        % P = [P, Points];
        qcircle = K*Points;
        qcircle = qcircle./repmat(qcircle(3,:),3,1);

        % Projected x and y coordinates
        x_proj = qcircle(1, front_angle);
        y_proj = qcircle(2, front_angle);

        if min(y_proj) < min(y_boundary)
            continue;
        end

        he(counter) = i*dh;
        rh(counter) = radius;
        theta_indices = 1:length(x_proj);

        % Use inpolygon to find points within the boundary
        % [in, ~] = inpolygon(x_proj, y_proj, x_boundary, y_boundary);
        % theta_indices = find(in);
        % 
        % if isempty(theta_indices)
        %     theta_indices = 1:w;
        %     % counter = counter + 1;
        %     % continue;
        % end

        % theta_indices = 1:w;
        % Rotate the points
        rotated_p = R' * qcircle(1:2, front_angle(theta_indices));
        q = rotated_p;
         % Plot every 15th circle for visualization
        if rem(counter, 10) == 0
            plot(rotated_p(1, :), rotated_p(2, :), 'g', 'linewidth', 0.5);
            drawnow
        end

        % Get indices for image extraction
        y_ind = get_idx(q, 2, 1:length(theta_indices), row);
        x_ind = get_idx(q, 1, 1:length(theta_indices), col);
        y_rep = repmat(y_ind, [3, 1]); % Size: [3, N]
        x_rep = repmat(x_ind, [3, 1]); % Size: [3, N]
        
        % Correct the replication of color indices to size [3, N]
        color_indices = repmat([1; 2; 3], [1, length(theta_indices)]); % Size: [3, N]
        % Now all arrays have the same size and can be used in sub2ind
        lin = sub2ind(size(Image), y_rep, x_rep, color_indices);

        RGB_original = reshape(Image(lin), [3, length(theta_indices)]).';  % Now [N, 3]

        % RGB_interpolated = interpolate_RGB(RGB_original, theta_indices, w);

        surface_patterns(counter, theta_indices, :) = RGB_original;

        counter = counter + 1;


        % rotated_p = R' * qcircle(1:2,:);
        % q = rotated_p(:, front_angle);
        % hold on;
        % if rem(counter,15) == 0
        %     plot(rotated_p(1,:), rotated_p(2,:),'g', 'linewidth',0.5);
        %     drawnow
        % end
        % 
        % 
        % y_ind = get_idx(q, 2, 1:w, row);
        % x_ind = get_idx(q, 1, 1:w, col);
        % lin = sub2ind(size(Image), repmat(y_ind, [3 1]), repmat(x_ind,...
        %     [3 1]), repmat([1;2;3], [1,w]));
        % surface_patterns(counter, 1:w, :) = Image(lin)';
        % 
        % 
        % counter = counter+1;
    end
    
    
    filtered_radius = imgaussfilt(rh, 10);
    profile = [he; filtered_radius];

    % 3D points
    % P = reshape(P, [], 2*w, h);
    % P = permute(P, [3,2,1]);
    % X = P(:,:,1);
    % Y = P(:,:,2);
    % Z = P(:,:,3);
    %% Upsample
    % upsamplingFactor = 16;
    % % Upsample the coordinates
    % upsampledPointsX = interp1(1:size(points, 2), points(1, :), linspace(1, size(points, 2), size(points, 2) * upsamplingFactor), 'linear');
    % upsampledPointsY = interp1(1:size(points, 2), points(2, :), linspace(1, size(points, 2), size(points, 2) * upsamplingFactor), 'linear');
    % upsampledPointsZ = interp1(1:size(points, 2), points(3, :), linspace(1, size(points, 2), size(points, 2) * upsamplingFactor), 'linear');
    % 
    % % Combine the upsampled coordinates
    % upsampledPoints = [upsampledPointsX; upsampledPointsY; upsampledPointsZ];
    % upsampledPoints = reshape(upsampledPoints, [], 8*w, 4*l);
    % upsampledPoints = permute(upsampledPoints, [3,2,1]);
    % 
    % X = upsampledPoints(:,:,1);
    % Y = upsampledPoints(:,:,2);
    % Z = upsampledPoints(:,:,3);


end


function RGB_interpolated = interpolate_RGB(RGB_original, x, new_length)
    % interpolate_RGB Interpolates RGB values from original to new_length
    %
    % Inputs:
    %   RGB_original - Original RGB values (N x 3 matrix)
    %   new_length   - Desired number of RGB points (scalar)
    %
    % Output:
    %   RGB_interpolated - Interpolated RGB values (new_length x 3 matrix)
    %
    % Example usage:
    %   RGB_interpolated = interpolate_RGB(RGB_original, 384);
   [~, num_channels] = size(RGB_original);
    if num_channels ~= 3
        error('RGB_original must be an N x 3 matrix, where N is the number of points.');
    end
   
    % Convert to double for accurate interpolation
    RGB_original = double(RGB_original);
    
    % Define original and new sampling points
    x_original = x/new_length;
    x_new = linspace(0, 1, new_length);           % Normalized new indices for interpolation
    
    % Initialize the interpolated RGB array
    RGB_interpolated = zeros(new_length, 3);
    
    % Interpolate each color channel separately
    for channel = 1:3
        % Extract the original channel data
        channel_data = RGB_original(:, channel);
        
        % Perform the interpolation using 'spline' for smoothness
        interpolated_channel = interp1(x_original, channel_data, x_new, 'spline');
        
        % Handle any NaNs resulting from interpolation outside the original range
        % Although 'spline' with 'x_new' in [0,1] should not produce NaNs,
        % it's good practice to ensure no NaNs are present.
        interpolated_channel(isnan(interpolated_channel)) = channel_data(end);
        
        % Assign the interpolated channel to the output array
        RGB_interpolated(:, channel) = interpolated_channel;
    end
    
    % Ensure values are within valid RGB range [0, 255]
    RGB_interpolated = max(min(RGB_interpolated, 255), 0);
    
    % Convert back to uint8
    RGB_interpolated = uint8(round(RGB_interpolated));



    % % Initialize the interpolated RGB array
    % RGB_interpolated = zeros(new_length, 3);
    % % Interpolate each color channel separately
    % for channel = 1:3
    %     % Extract the original channel data
    %     channel_data = RGB_original(:, channel);
    % 
    %     % Perform the interpolation
    %     % You can change 'linear' to 'spline' or 'pchip' if smoother interpolation is desired
    %     RGB_interpolated(:, channel) = round(interp1(x_original, channel_data, x_new, 'linear'));
    % end
    % RGB_interpolated = uint8(RGB_interpolated);

end

