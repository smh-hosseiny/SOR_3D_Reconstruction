function run(Image, point_cloud)

nrow = size(Image, 1);
ncol = size(Image, 2);

message = ['Please locate some points on the borders of the object' ...
' (around 15 points). When you are done press Enter.'];

[xCoordinates, yCoordinates] = get_input(Image, message);
%
fprintf('\ninitializing ...');
tic
f = 1200;
cx = ncol/2;
cy = nrow/2;
K = [f 0 cx;0 f cy;0 0 1];
dh = 0.01;

[x,y,n,Pbase,p1] = get_border(xCoordinates, yCoordinates, K);

e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);
[reference, s1, s2] = get_surface_patterns(Image,nrow,ncol,x,y,K,n);

% find angle
fprintf('\nfinding best angle...');
tic
best_angle = find_angle(Image,x,y,nrow,s1,s2,n,reference,Pbase,K,p1,dh);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);


%fit ellipse
fprintf('\nfitting ellipses ...');
tic
close;
figure; imshow(Image); 
[lb, ub] = get_range(n, best_angle, x,y, Pbase, K, p1, nrow, dh);
[profile,na,a,b] = fit_profile(n, best_angle, Pbase, K, p1, lb, ub, dh);
axis equal;
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);

% project patterns
fprintf('\nprojecting patterns ...');
tic
[imgq,~] = project_patterns(lb,ub,dh,profile,Pbase,na,a,b,Image,K);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);


% reconstructing 3D dome
fprintf('\nreconstructing 3D dome ...');
tic
[X,Y,Z,C] = plot3D(lb, ub, profile, dh, imgq);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);


if point_cloud == 1
    xyz = cat(3, X,Y,Z);
    ptCloud = pointCloud(xyz, 'Color',C);
    pcwrite(ptCloud,'object3d.ply');
    figure; pcshow(ptCloud); title('3D Point cloud');
end

end

