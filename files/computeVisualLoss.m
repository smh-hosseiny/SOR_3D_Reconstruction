function loss = computeVisualLoss(ang, n, R, Pbase, K, p1, dh, top_point, ...
    bot_point, f, masked, y, region_mask, symmetry_angle)

% COMPUTEVISUALLOSS Computes the visual loss for a given 3D model.
%
%   loss = COMPUTEVISUALLOSS(ang, n, R, Pbase, K, p1, dh, top_point, ...
%       bot_point, f, masked, y, region_mask, symmetry_angle)
%
%   This function calculates a loss value representing the difference between
%   the projected surface patterns and the reference image. It is used
%   in optimization routines to find the best rotation angle that minimizes
%   this surface reporjection loss.
%
%   Inputs:
%       ang             - Rotation angle (in degrees) to be evaluated.
%       n               - Normal vector of the object's symmetry plane.
%       R               - Rotation matrix for aligning the object.
%       Pbase           - Base point in 3D space from which calculations start.
%       K               - Camera intrinsic matrix.
%       p1              - Initial projection point.
%       dh              - Height increment.
%       top_point       - Coordinates of the top point of the object.
%       bot_point       - Coordinates of the bottom point of the object.
%       f               - Focal length of the camera.
%       masked          - Grayscale masked image of the object.
%       y               - Y-coordinates of the object's boundary points.
%       region_mask     - Binary mask defining the region of interest in the image.
%       symmetry_angle  - Symmetry angle of the object, used in surface projection.
%
%   Output:
%       loss    - Scalar value representing the computed loss.
%
%   Example:
%       loss = computeVisualLoss(ang, n, R, Pbase, K, p1, dh, top_point, ...
%           bot_point, f, masked, y, region_mask, symmetry_angle);
%
%   Notes:
%       - The function combines structural similarity index (SSIM) loss and L1 loss
%         to compute the overall loss.



    % Compute the depth range (lb and ub) for the given rotation angle
    [lb, ub] = get_range(n, ang, Pbase, K, p1, dh, top_point, bot_point, f, y, region_mask);

    % Perform surface projection to obtain the patterns at the given angle
    [patterns, status] = surface_projection(masked, R, n, Pbase, K, p1, lb, ub, dh, ...
        bot_point, ang, f, region_mask, symmetry_angle);

    % Check if the surface projection was successful
    if status ~= 0
        % Assign a high loss value if projection failed
        loss = 1e4;
        return;
    end

    % Optional image registration
    % The registration can be used to align the projected patterns with the reference image
    % try
    %     patterns = register_img(masked, patterns);
    % catch
    % 
    % end

    % Weighting factor for combining losses
    lambda = 0.05;

    % Compute the Structural Similarity Index (SSIM) loss
    % SSIM measures the similarity between two images
    ssim_loss = 1 - ssim(patterns, masked);

    % Compute the L1 loss (mean absolute error) between the patterns and the masked image
    l1_loss = mean(abs(double(patterns(:)) - double(masked(:))));

    % Combine the SSIM loss and L1 loss using the weighting factor lambda
    loss = lambda * l1_loss + (1 - lambda) * ssim_loss;

end