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
mask_clean = imclose(mask, strel('disk', 3));
mask = imgaussfilt(double(mask_clean), 1) > 0.5;
mask = imopen(mask, strel('disk', 3));

Image = imread(img_dir);
nrow = size(Image, 1);
ncol = size(Image, 2);
%% 

[symmetry_angle, mask2, lx,ly,rx,ry,top_point,R] = get_input(mask);


%%
tic;
fprintf('\ninitializing ...');

f = 750;
cx = ncol/2;
cy = nrow/2;
K = [f 0 cx;0 f cy;0 0 1];

dh = 0.01;
figure;
imshow(Image);
hold on;

[x,y,n,Pbase,p1,top_point,bot_point,xs,ys] = get_border(lx,ly,rx,ry,top_point,K,R);
rotated_p = (R' * [x;y])';
plot(rotated_p(:,1),rotated_p(:,2),'r.','linewidth',1);
drawnow;
x_min = min(rotated_p(:,1));
x_max = max(rotated_p(:,1));
y_min = min(rotated_p(:,2));
y_max = max(rotated_p(:,2));


rotated_p = (R' * [xs;ys])';
hold on;
plot(rotated_p(:,1), rotated_p(:,2), '--','color', 'c', 'linewidth',2);

t = (R' * top_point')';
plot(t(1),t(2), 'k*');
e2 = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e2);
title('Detected boundary and symmetry line');


% Ensure coordinates are within image boundaries
x_min = max(1, floor(x_min));
x_max = min(ncol, ceil(x_max));
y_min = max(1, floor(y_min));
y_max = min(nrow, ceil(y_max));
crop_rect = [x_min, y_min, x_max - x_min, y_max - y_min];

masked = uint8(double(Image) .* mask);
% Crop the masked image
reference = imcrop(masked, crop_rect);


%% find angle
fprintf('\nfinding best angle...');
tic

try
    [best_angle, best_loss] = find_angle(nrow, n, reference, masked, Pbase, K,p1, ...
        dh, top_point, bot_point, f, R, x, y, mask2, symmetry_angle);
catch
    warning('An error occurred while finding the best angle. Using 0 as the best angle.');
    best_angle = 0;
    best_loss = 0;
end
e3 = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e3);



%% find focal length
fprintf('\nfinding best focal length...');
tic

[best_focal, K] = optimizeFocal(nrow, reference, masked, K, dh, top_point, R, ...
    best_angle,lx,ly,rx,ry,mask2,f,best_loss,symmetry_angle);
% best_focal = optimizeFocal(nrow, n, reference, masked, Pbase, K, p1, dh, top_point, bot_point, R, best_angle);

[x,y,n,Pbase,p1,top_point,bot_point] = get_border(lx,ly,rx,ry,top_point,K,R);

% dh = dh * (f/best_focal);
f = best_focal;

e6 = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e6);


%% reconstructing 3D dome
fprintf('\nfitting ellipses ...');
tic

hold on;

[lb, ub] = get_range(n, best_angle, Pbase, K, p1, nrow, dh,top_point,bot_point,f,x,y,mask2,2000);
% [profile,na,a,b,front_angle] = fit_profile(n, best_angle, Pbase, K, p1, lb, ub, dh, f,bot_point, R);
[surface_patterns, profile] = fit_profile(Image,n, best_angle, Pbase, K, p1, ...
    lb, ub, dh,f,bot_point,R,x,y,mask2,symmetry_angle);
 
axis equal;
title('Detected boundary and symmetry line + 2D profile');
e4 = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e4);
% saveas(gcf, strcat(out_folder, imgName, '_2D_profile.jpg'));

%% Visualization
tic 

[X,Y,Z,C] = plot3D(lb, ub, profile, dh, surface_patterns);

xyz = cat(3, X,Y,Z);
ptCloud = pointCloud(xyz, 'Color',C);
figure; pcshow(ptCloud, 'ViewPlane', 'XZ'); 
toc
title('3D Point cloud');
view(0, 10);

% Set axis labels
xlabel('X (centimeters)');
ylabel('Y (centimeters)');
zlabel('Z (centimeters)');
grid on;

if point_cloud == 1
    pcwrite(ptCloud, strcat(out_folder, imgName, '_3D_obj.ply'));
end

e5 = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e5);
fprintf('\tTotal runtume: %.2fs \n',e1+e2+e3+e4+e5+e6);

end
