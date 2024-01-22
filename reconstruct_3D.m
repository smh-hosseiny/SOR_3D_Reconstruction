function reconstruct_3D(img_dir, point_cloud, output_dir)

addpath("files/");

if nargin < 1 || isempty(img_dir)
    error('img_dir is missing or empty.');
end
% Check if point_cloud is missing or empty
if nargin < 2 || isempty(point_cloud)
    point_cloud = 1; 
end

% Check if output_dir is missing or empty
if nargin < 3 || isempty(output_dir)
    output_dir = pwd;
end


out_folder = strcat(output_dir,'/results/');
if ~isfolder(out_folder)
    mkdir(out_folder);
end


run(img_dir, point_cloud, out_folder);

disp(['Outputs are saved at', out_folder]);


end