function run(img_dir, point_cloud, out_folder)
tic

[~, imgName, imgExt] = fileparts(img_dir);

command = sprintf('remove_bg.py "%s" "%s"', img_dir, out_folder(1:end-1));
pyrunfile(command);
e1 = toc;
%%
img_name = sprintf("%s/%s_mask%s"', out_folder,imgName,imgExt);
mask = imread(img_name);
mask = im2bw(mask); 
Image = imread(img_dir);
nrow = size(Image, 1);
ncol = size(Image, 2);
%%
tic
boundaries = bwperim(mask);
[lx,ly,rx,ry,top_point,R] = get_input(boundaries);

%
fprintf('\ninitializing ...');

field_of_view = 40;
f = size(Image,2)/(2 * tand(field_of_view/2));
cx = ncol/2;
cy = nrow/2;
K = [f 0 cx;0 f cy;0 0 1];
dh = 0.01;
figure;
imshow(Image);
hold on;

[x,y,n,Pbase,p1,top_point,bot_point] = get_border(lx,ly,rx,ry,top_point,K,R);
rotated_p = (R' * [x;y])';
plot(rotated_p(:,1),rotated_p(:,2),'r.','linewidth',1);
drawnow;
e2 = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e2);
title('Detected boundary and symmetry line');


x_1 = min(rotated_p(:,1));
x_2 = max(rotated_p(:,1));
y_1 = min(rotated_p(:,2));
y_2 = max(rotated_p(:,2));
masked = uint8(mask .* double(Image));
reference = imcrop(masked, [min(x_1,x_2), min(y_1,y_2), abs(x_2 - x_1), abs(y_2 - y_1)]);

%% find angle
fprintf('\nfinding best angle...');
tic
best_angle = find_angle(nrow,n,reference,masked,Pbase,K,p1,dh,top_point,bot_point,f,R);
e3 = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e3);


%% reconstructing 3D dome
fprintf('\nfitting ellipses ...');
tic
[lb, ub] = get_range(n, best_angle, Pbase, K, p1, nrow, dh,top_point,bot_point,f,2000);
% [profile,na,a,b,front_angle] = fit_profile(n, best_angle, Pbase, K, p1, lb, ub, dh, f,bot_point, R);
[surface_patterns, profile] = fit_profile(Image,n, best_angle, Pbase, K, p1, lb, ub, dh,f,bot_point,R);
 
axis equal;
title('Detected boundary and symmetry line + 2D profile');
e4 = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e4);
saveas(gcf, strcat(out_folder, imgName, '_2D_profile.jpg'));

%% Visualization
tic 

[x,y,z,C] = plot3D(lb, ub, profile, dh, surface_patterns);

xyz = cat(3, x,y,z);
ptCloud = pointCloud(xyz, 'Color',C);
figure; pcshow(ptCloud, 'ViewPlane', 'XZ'); 
toc
title('3D Point cloud');
view(0, 10);

% Set axis labels
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
grid on;

if point_cloud == 1
    pcwrite(ptCloud, strcat(out_folder, imgName, '_3D_obj.ply'));
end

e5 = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e5);
fprintf('\tTotal runtume: %.2fs \n',e1+e2+e3+e4+e5);

end
