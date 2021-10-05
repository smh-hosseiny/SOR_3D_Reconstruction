function GUI

addpath('files');
clc; clear;
image = imread('files/TheDome.jpg');
f = figure('Visible','off','Position',[360,500,300,230]);
ha = axes('unit', 'normalized', 'position', [0 0 1 1]);
imagesc(image);

h1 = uicontrol('Style','pushbutton','String','Path to image',...
           'Position',[115,150,80,30], 'Callback',{@Pathbutton_Callback});

h2 = uicontrol('Style','checkbox',...
           'String',{'Save Point cloud output'},...
           'Position',[85,105,130,28],'Callback',{@checkbox_Callback});
       
h3 = uicontrol('Style','pushbutton','String','Run',...
           'Position',[115,70,70,25],'Callback',{@Runbutton_Callback});
 

align([h1,h2,h3],'Center','None');

f.Units = 'normalized';
h1.Units = 'normalized';
h2.Units = 'normalized';
h3.Units = 'normalized';
f.Name = 'GUI';
movegui(f,'center')
f.Visible = 'on';
end


function Pathbutton_Callback(source,eventdata) 
global Image_of_dome;

[file,path] = uigetfile('*.png; *.jpg; *.jpeg',...
               'Select an image');
selectedfile = fullfile(path,file);
Image_of_dome = imread(selectedfile);
end

function checkbox_Callback(source,eventdata)
global point_cloud;
point_cloud = source.Value;

end

function Runbutton_Callback(source,eventdata)
    global Image_of_dome;
    global point_cloud;
    
    close;
    run(Image_of_dome, point_cloud);
    GUI;
end
