function GUI

addpath('files');
% clc; clear;
image = imread('files/TheDome.jpg');
f = figure('Visible','off','Position',[360,500,300,230]);
ha = axes('unit', 'normalized', 'position', [0 0 1 1]);
imagesc(image);

% global current_folder;
% current_folder = pwd;

% Construct the components.
h1 = uicontrol('Style','pushbutton','String','Path to image',...
           'Position',[115,150,80,30], 'Callback',{@Pathbutton_Callback});
% h2  = uicontrol('Style','text','String','Choose Method',...
%            'Position',[315,170,100,15]);
       
% h3 = uicontrol('Style','popupmenu',...
%            'String',{'---','Fast','Slow'},...
%            'Position',[300,140,100,25],'Callback',{@popup_menu_Callback});
       
h4 = uicontrol('Style','pushbutton','String','Run',...
           'Position',[115,70,70,25],'Callback',{@Runbutton_Callback});
 


align([h1,h4],'Center','None');

f.Units = 'normalized';
h1.Units = 'normalized';
% h2.Units = 'normalized';
% h3.Units = 'normalized';
h4.Units = 'normalized';
f.Name = 'GUI';
movegui(f,'center')
f.Visible = 'on';
end


function Pathbutton_Callback(source,eventdata) 
global Image_of_dome;
% global current_folder;
% cd(current_folder);
[file,path] = uigetfile('*.png; *.jpg; *.jpeg',...
               'Select an image');
selectedfile = fullfile(path,file);
Image_of_dome = imread(selectedfile);
end

function Runbutton_Callback(source,eventdata)
    global Image_of_dome;
    close;
    run(Image_of_dome);
    GUI;
end
