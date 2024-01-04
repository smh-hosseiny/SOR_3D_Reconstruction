function run(img_dir, point_cloud)
% img_dir = '/Users/seyedhosseini/Downloads/T I/13.JPG';

output_dir = pwd;
[~, imgName, imgExt] = fileparts(img_dir);

command = sprintf('Functions/remove_bg.py "%s" "%s"', img_dir, output_dir);
pyrunfile(command)
%%
img_name = sprintf("%s/%s_no_bg%s"', output_dir,imgName,imgExt);
mask = imread(img_name);
mask = im2bw(mask); 

%%
Image = imread(img_dir);
nrow = size(Image, 1);
ncol = size(Image, 2);
%%
boundaries = bwperim(mask);
[lx,ly,rx,ry,top_point,R] = get_input(boundaries);


%%
fprintf('\ninitializing ...');
tic
field_of_view = 26;
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
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);
title('Detected boundary and symmetry line');
% [reference, s1, s2] = get_surface_patterns(Image,nrow,ncol,p1,K,n);
reference = uint8(mask .* double(Image));

%% find angle
fprintf('\nfinding best angle...');
tic
best_angle = find_angle(nrow,n,reference,Pbase,K,p1,dh,top_point,bot_point,f,R);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);


%% fit ellipse
fprintf('\nfitting ellipses ...');
tic
[lb, ub] = get_range(n, best_angle, Pbase, K, p1, nrow, dh,top_point,bot_point,f);
[profile,na,a,b,front_angle] = fit_profile(n, best_angle, Pbase, K, p1, lb, ub, dh, f,bot_point, R);
axis equal;
title('Detected boundary and symmetry line + 2D profile');
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);

%% project patterns
fprintf('\nprojecting patterns ...');
tic
pattern = project_patterns(lb,ub,dh,profile,Pbase,na,a,b,Image,K,front_angle,R);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);


%% reconstructing 3D dome
fprintf('\nreconstructing 3D dome ...');
tic
[X,Y,Z,C] = plot3D(lb, ub, profile, dh, pattern, n);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);

xyz = cat(3, X,Y,Z);
ptCloud = pointCloud(xyz, 'Color',C);
figure; pcshow(ptCloud); title('3D Point cloud');
if ismember(181, front_angle)
    view(180, 15);
else
    view(0, 15);
end
if point_cloud == 1
    pcwrite(ptCloud,'object3d.ply');
end

delete(img_name);

end
