function [surface_patterns, profile, lb, ub] = fit_ellipses_and_reconstruct(img, n, ...
    best_angle, Pbase, K, p1, dh, top_point, bot_point, f, R, x, y, mask2, symmetry_angle)
    

%FIT_ELLIPSES_AND_RECONSTRUCT Fits ellipses to object contours and reconstructs the 3D model.
%
%   [surface_patterns, profile, lb, ub] = FIT_ELLIPSES_AND_RECONSTRUCT(img, n, ...
%       best_angle, Pbase, K, p1, dh, top_point, bot_point, f, R, x, y, mask2, symmetry_angle)
%
%   This function fits ellipses to the object's contours at different heights and uses
%   these to reconstruct the 3D model of the object. It computes the
%   range of height to consider and then fits the profile of the object.
%
%   Inputs:
%       img             - Original RGB image of the object.
%       n               - Normal of the symmetry plane.
%       best_angle      - Best angle of the axis of revolution.
%       Pbase           - Base points used in computations.
%       K               - Camera intrinsic matrix.
%       p1              - Initial projection point.
%       dh              - Height increment.
%       top_point       - Coordinates of the top point of the object.
%       bot_point       - Coordinates of the bottom point of the object.
%       f               - Focal length of the camera.
%       R               - Rotation matrix for alignment.
%       x, y            - Coordinates of the object's boundary points.
%       mask2           - Rotated mask.
%       symmetry_angle  - Initial estimate of the symmetry angle.
%
%   Outputs:
%       surface_patterns    - Patterns of the object's surface used in reconstruction.
%       profile             - Generating function: Fitted profile of the object.
%       lb, ub              - Lower and upper bounds of the height range considered.


    [lb, ub] = get_range(n, best_angle, Pbase, K, p1, dh, top_point, bot_point, ...
        f, y, mask2, 2000);

    hold on;
    [surface_patterns, profile] = fit_profile(img, n, best_angle, Pbase, K, ...
        p1, lb, ub, dh, f, bot_point, R, x, y, mask2, symmetry_angle);


end