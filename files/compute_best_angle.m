function [best_angle,best_loss] = compute_best_angle(n, reference_img, Pbase, ...
    K, p1, dh, top_point, bot_point, f, R, y, mask2, symmetry_angle)

%COMPUTE_BEST_ANGLE Computes the optimal axis of revolution for the object.
%
%   [best_angle, best_loss] = COMPUTE_BEST_ANGLE(n, reference_img, Pbase, ...
%       K, p1, dh, top_point, bot_point, f, R, y, mask2, symmetry_angle)
%
%   This function finds the best angle that represents the precise axis of
%   revolution of the object by minimizing the visual loss function. 
%
%   Inputs:
%       n               - Normal of the symmetry plane.
%       reference_img   - Grayscale reference image of the object.
%       Pbase           - Base points used in the computation.
%       K               - Camera intrinsic matrix.
%       p1              - Initial projection point.
%       dh              - Height increment.
%       top_point       - Coordinates of the top point of the object.
%       bot_point       - Coordinates of the bottom point of the object.
%       f               - Focal length of the camera.
%       R               - Rotation matrix for alignment.
%       y               - Y-coordinates of the boundary points.
%       mask2           - Rotated mask
%       symmetry_angle  - Initial estimate of the symmetry angle.
%
%   Outputs:
%       best_angle  - Best angle (in degrees) of the axis of revolution
%       best_loss   - Corresponding loss value for the best angle.

    try
        [best_angle, best_loss] = find_angle(n, reference_img, Pbase, K, p1, ...
            dh, top_point, bot_point, f, R, y, mask2, symmetry_angle);
    catch
        fprintf('An error occurred while finding the best angle. Using 0 as the best angle.');
        best_angle = 0;
        best_loss = 0;
    end


end