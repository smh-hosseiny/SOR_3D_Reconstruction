function run(Image, point_cloud)

nrow = size(Image, 1);
ncol = size(Image, 2);

message = ['Please locate 10-15 points on the border of the object' ...
' (starting from bottom left and ending at bottom right). When you are done press Enter.'];

[xCoordinates, yCoordinates] = get_input(Image, message);
%
fprintf('\ninitializing ...');
tic
f = 1000;
cx = ncol/2;
cy = nrow/2;
K = [f 0 cx;0 f cy;0 0 1];
dh = 0.01;

[x,y,n,Pbase,p1,top_point] = get_border(xCoordinates, yCoordinates,nrow, ncol, K);
hold on;
plot(x,y,'r','linewidth',1);
drawnow;
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);

[reference, s1, s2] = get_surface_patterns(Image,nrow,ncol,p1,K,n);

% find angle
fprintf('\nfinding best angle...');
tic
best_angle = find_angle(Image,nrow,s1,s2,n,reference,Pbase,K,p1,dh,top_point,f);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);


%fit ellipse
fprintf('\nfitting ellipses ...');
tic
[lb, ub] = get_range(n, best_angle, Pbase, K, p1, nrow, dh,top_point, f);
[profile,na,a,b] = fit_profile(n, best_angle, Pbase, K, p1, lb, ub, dh, f);
axis equal;
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);

% project patterns
fprintf('\nprojecting patterns ...');
tic
[I,~] = project_patterns(lb,ub,dh,profile,Pbase,na,a,b,Image,K);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);

% reconstructing 3D dome
fprintf('\nreconstructing 3D dome ...');
tic
[X,Y,Z,C] = plot3D(lb, ub, profile, dh, I, n);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);


if point_cloud == 1
    xyz = cat(3, X,Y,Z);
    ptCloud = pointCloud(xyz, 'Color',C);
    pcwrite(ptCloud,'object3d.ply');
    figure; pcshow(ptCloud); title('3D Point cloud');
end

end

