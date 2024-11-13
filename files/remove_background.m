function [mask_path, img_name] = remove_background(img_path, output_folder)
%REMOVE_BACKGROUND Removes the background from an image using an external Python script.
%
%   [mask_path, img_name] = REMOVE_BACKGROUND(img_path, output_folder)
%
%   This function calls an external Python script to remove the background from
%   the input image and saves the resulting mask in the specified output folder.
%
%   Inputs:
%       img_path      - String specifying the path to the input image file.
%       output_folder - String specifying the directory where output files should be saved.
%
%   Outputs:
%       mask_path - String specifying the path to the generated mask image.
%       img_name  - String containing the name of the input image file (without extension).
%
%   Example:
%       [mask_path, img_name] = remove_background('images/object.jpg', 'output/');
%
%   Notes:
%       - This function relies on an external Python script 'remove_bg.py' to perform
%         background removal. Ensure that Python is properly configured in MATLAB and
%         that the script is accessible from the MATLAB environment.


    % Extract the image name and extension from the image path
    [~, img_name, img_ext] = fileparts(img_path);

    % The command includes the script name and the arguments (image path and output folder)
    command = sprintf('remove_bg.py "%s" "%s"', img_path, output_folder);

    % This requires that Python is configured in MATLAB and 'remove_bg.py' is accessible
    pyrunfile(command);

    % The mask image is expected to be named '<img_name>_mask<img_ext>' and saved in the output folder
    mask_path = fullfile(output_folder, sprintf('%s_mask%s', img_name, img_ext));

end