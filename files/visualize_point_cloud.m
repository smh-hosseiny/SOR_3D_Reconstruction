function visualize_point_cloud(lb, ub, profile, dh, surface_patterns, output_folder, ...
    img_name, point_cloud_flag)

%VISUALIZE_POINT_CLOUD Generates and displays the 3D point cloud of the reconstructed model.
%
%   visualize_point_cloud(lb, ub, profile, dh, surface_patterns, output_folder, ...
%       img_name, point_cloud_flag)
%
%   This function generates the 3D point cloud from the reconstructed surface patterns
%   and displays it. If specified, it also saves the point cloud to a file.
%
%   Inputs:
%       lb, ub              - Lower and upper bounds of the height range.
%       profile             - Generating function: Fitted profile of the object.
%       dh                  - Height increment.
%       surface_patterns    - Patterns of the object's surface used in reconstruction.
%       output_folder       - Directory where output files should be saved.
%       img_name            - Name of the input image (used for naming output files).
%       point_cloud_flag    - Boolean flag indicating whether to save the point cloud (1 to save, 0 otherwise).


    [X, Y, Z, C] = plot3D(lb, ub, profile, dh, surface_patterns);

    xyz = [X(:), Y(:), Z(:)];
    colors = reshape(C, [], 3);
    ptCloud = pointCloud(xyz, 'Color', colors);

    fig = figure('Position', [100 100 800 600], 'Color', 'white');
   
    % Create main axes for point cloud
    ax = axes('Color', 'white');  
    pcshow(ptCloud, 'ViewPlane', 'XZ', 'BackgroundColor', 'white'); 
    grid off
    axis off
    title('3D Point cloud', 'FontSize', 20);
    view(-3, 15);


    if point_cloud_flag == 1
       pcwrite(ptCloud, fullfile(output_folder, [img_name, '_3D_obj.ply']));
       saveas(fig, fullfile(output_folder, [img_name, '_3D_visualization.png']));
    end

    

end
