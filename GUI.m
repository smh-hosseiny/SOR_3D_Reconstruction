function GUI
    addpath('files/');
    image = imread('files/TheDome.jpg');

    f = figure('Visible', 'off', 'Position', [360, 500, 300, 230], 'NumberTitle', 'off', 'Resize', 'on');

    ha = axes('unit', 'normalized', 'position', [0 0 1 1]);
    imagesc(image);

    h1 = uicontrol('Style', 'pushbutton', 'String', 'Path to image', ...
                   'Position', [115, 160, 90, 40], 'Callback', {@Pathbutton_Callback}, 'FontSize', 12);

    h2 = uicontrol('Style', 'checkbox', ...
                   'String', {'Save Point cloud output'}, ...
                   'Position', [85, 105, 130, 28], 'Callback', {@checkbox_Callback}, 'FontSize', 12);

    h3 = uicontrol('Style', 'pushbutton', 'String', 'Run', ...
                   'Position', [115, 60, 70, 25], 'Callback', {@Runbutton_Callback}, 'FontSize', 12);

    align([h1, h2, h3], 'Center', 'None');

    f.Units = 'normalized';
    h1.Units = 'normalized';
    h2.Units = 'normalized';
    h3.Units = 'normalized';
    f.Name = 'GUI';
    movegui(f, 'center');
    f.Visible = 'on';
end

% (Your other functions remain unchanged)



function Pathbutton_Callback(source,eventdata) 
global selectedfile;

[file,path] = uigetfile('*.png; *.jpg; *.jpeg',...
               'Select an image');
selectedfile = fullfile(path,file);
end

function checkbox_Callback(source,eventdata)
global point_cloud;
point_cloud = source.Value;

end

function Runbutton_Callback(source,eventdata)
    global selectedfile;
    global point_cloud;
    close;
    reconstruct_3D(selectedfile, point_cloud, [])
    GUI;    
end
