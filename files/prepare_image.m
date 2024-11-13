function [img, no_bg_img, reference_img, symmetry_angle, mask2, ...
    lx, ly, rx, ry, top_point, R] = prepare_image(img_path, mask_path)

%PREPARE_IMAGE Loads and preprocesses the input image and mask.
%
%   [img, no_bg_img, reference_img, symmetry_angle, mask2, ...
%    lx, ly, rx, ry, top_point, R] = PREPARE_IMAGE(img_path, mask_path)
%
%   This function reads the input image and its corresponding mask, applies
%   the mask to the image to remove the background, converts the masked image
%   to grayscale for reference, and extracts parameters necessary for further
%   processing, such as symmetry angle and rotation matrix.
%
%   Inputs:
%       img_path    - String specifying the path to the input RGB image.
%       mask_path   - String specifying the path to the mask image.
%
%   Outputs:
%       img             - Original RGB image loaded from img_path.
%       no_bg_img       - RGB image with background removed using the mask.
%       reference_img   - Grayscale version of the no_bg_img for reference.
%       symmetry_angle  - Estimated angle of symmetry of the object.
%       mask2           - Processed mask used for further computations.
%       lx, ly          - Coordinates of the left boundary of the object.
%       rx, ry          - Coordinates of the right boundary of the object.
%       top_point       - Coordinates of the top point of the object.
%       R               - Rotation matrix used for aligning the object.

    
    mask = imread(mask_path);
    if size(mask, 3) > 1
        mask = rgb2gray(mask);
    end
    mask = imbinarize(mask);
    mask = refine_mask(mask);

    img = imread(img_path);

    no_bg_img = img;
    no_bg_img(repmat(~mask, [1, 1, size(img, 3)])) = 0;
    reference_img = rgb2gray(no_bg_img);


    [symmetry_angle, mask2, lx, ly, rx, ry, top_point, R] = get_input(mask);
end