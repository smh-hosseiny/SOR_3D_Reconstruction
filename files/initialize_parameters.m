function [y, n, Pbase, p1, f, K, dh, top_point, bot_point] = initialize_parameters(lx, ...
    ly, rx, ry, top_point, R, no_bg_img)

%INITIALIZE_PARAMETERS Sets up initial symmetry plane parameters and computes boundaries.
%
%   [y, n, Pbase, p1, f, K, dh, top_point, bot_point] = INITIALIZE_PARAMETERS(...
%       lx, ly, rx, ry, top_point, R, no_bg_img)
%
%   This function initializes the symmetry plane, computes the object's
%   boundary points, and visualizes the detected boundary and symmetry line.
%
%   Inputs:
%       lx, ly      - Vectors containing the x and y coordinates of the left boundary.
%       rx, ry      - Vectors containing the x and y coordinates of the right boundary.
%       top_point   - Coordinates [x, y] of the top point of the object.
%       R           - Rotation matrix for aligning the object.
%       no_bg_img   - RGB image with the background removed.
%
%   Outputs:
%       y           - Y-coordinates of the boundary points.
%       n           - Normal of the symmetry plane
%       Pbase       - Base points used for 3D reconstruction.
%       p1          - Initial projection point.
%       f           - Initial focal length of the camera.
%       K           - Camera intrinsic matrix.
%       dh          - Height increment.
%       top_point   - Updated coordinates of the top point after processing.
%       bot_point   - Coordinates of the bottom point of the object.



    [nrow, ncol, ~] = size(no_bg_img);
    % Initial intrinsic matrix
    f = 750;
    cx = ncol / 2;
    cy = nrow / 2;
    K = [f, 0, cx; 0, f, cy; 0, 0, 1];

    dh = 0.01;

    % Display the image with boundary and symmetry line
    figure('Position', [100, 100, 2400, 1600]);
    imshow(no_bg_img);
    hold on;

    [x, y, n, Pbase, p1, top_point, bot_point, xs, ys] = get_border(lx, ly, rx, ry, top_point, K, R);
    rotated_p = (R' * [x; y])';
    plot(rotated_p(:, 1), rotated_p(:, 2), 'r*', 'LineWidth', 2);
    drawnow;

    rotated_sym = (R' * [xs; ys])';
    plot(rotated_sym(:, 1), rotated_sym(:, 2), '--', 'Color', 'c', 'LineWidth', 2);

    t = (R' * top_point')';
    plot(t(1), t(2), 'k*');
  
    title('Detected boundary and symmetry line');

end