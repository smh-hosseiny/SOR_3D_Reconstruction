function reconstruct_3D(img_path, point_cloud, output_dir)

% RECONSTRUCT_3D Reconstructs a scaled 3D model from a single image.
%
% Usage:
%   reconstruct_3D(img_path, point_cloud, output_dir)
%
% Inputs:
%   img_path    - Path to the input image file.
%   point_cloud - Flag to save the point cloud (1 to save, 0 otherwise). Optional; default is 1.
%   output_dir  - Directory to save output files. Optional; default is the current directory.
%
% Example:
%   reconstruct_3D('images/object.jpg', 1, 'output/')
%
% Outputs:
%   The outputs are saved in the specified output directory.
%
% See also: RUN

    % Add necessary paths
    addpath('files/');

    % Validate input arguments
    if nargin < 1 || isempty(img_path)
        error('img_path is missing or empty.');
    end
    if ~exist(img_path, 'file')
        error('The image file does not exist: %s', img_path);
    end
    if nargin < 2 || isempty(point_cloud)
        point_cloud = 1; 
    end
    if ~ismember(point_cloud, [0, 1])
        error('point_cloud must be 0 or 1.');
    end
    if nargin < 3 || isempty(output_dir)
        output_dir = pwd;
    end

    % Ensure output directory exists
    out_folder = fullfile(output_dir, 'results');
    if ~isfolder(out_folder)
        mkdir(out_folder);
    end

    % Run the reconstruction process
    try
        run(img_path, point_cloud, out_folder);
    catch ME
        error('An error occurred during reconstruction: %s', ME.message);
    end

    % Display output location
    disp(['Outputs are saved at ', out_folder]);
end