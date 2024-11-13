function [f, K, dh, x, y, n, Pbase, p1, top_point, bot_point] = optimize_focal_length(reference_img, ...
    K, dh, top_point, R, best_angle, lx, ly, rx, ry, mask2, f, best_loss, symmetry_angle)

%OPTIMIZE_FOCAL_LENGTH Optimizes the camera's focal length to improve reconstruction accuracy.
%
%   [f, K, dh, x, y, n, Pbase, p1, top_point, bot_point] = OPTIMIZE_FOCAL_LENGTH(...
%       reference_img, K, dh, top_point, R, best_angle, lx, ly, rx, ry, mask2, f, ...
%       best_loss, symmetry_angle)
%
%   This function attempts to optimize the camera's focal length using the provided
%   inputs to scale the 3D model. It updates the intrinsic
%   matrix K and recomputes the object's boundary points.
%
%   Inputs:
%       reference_img   - Grayscale reference image of the object.
%       K               - Current camera intrinsic matrix.
%       dh              - Height increment.
%       top_point       - Coordinates of the top point of the object.
%       R               - Rotation matrix for alignment.
%       best_angle      - Best angle of the axis of revolution.
%       lx, ly          - Coordinates of the left boundary of the object.
%       rx, ry          - Coordinates of the right boundary of the object.
%       mask2           - Rptated mask.
%       f               - Current focal length of the camera.
%       best_loss       - Best loss value from previous computations.
%       symmetry_angle  - Initial estimate of the symmetry angle.
%
%   Outputs:
%       f           - Optimized focal length of the camera.
%       K           - Updated camera intrinsic matrix with the optimized focal length.
%       dh          - Updated height increment.
%       x, y        - Coordinates of the object's boundary points.
%       n           - Normal of the symmetry plane
%       Pbase       - Base points used in 3D reconstruction.
%       p1          - Initial projection point.
%       top_point   - Updated coordinates of the top point after processing.
%       bot_point   - Coordinates of the bottom point of the object.


   try
        [best_focal, K, dh] = optimizeFocal(reference_img, K, dh, top_point, ...
            R, best_angle, lx, ly, rx, ry, mask2, f, best_loss, symmetry_angle);

        [x, y, n, Pbase, p1, top_point, bot_point] = get_border(lx, ly, rx, ...
            ry, top_point, K, R);
        f = best_focal;
    catch
        fprintf('An error occurred while finding the best focal length. Using 750 as f.');
    end

end