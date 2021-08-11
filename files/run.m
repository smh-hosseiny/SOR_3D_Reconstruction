function run(Image)

nrow = size(Image, 1);
ncol = size(Image, 2);

message = ['Please locate some points on the borders of the object by clicking on them.' ...
' (10-15 points). When you are done press Enter.'];

[xCoordinates, yCoordinates] = get_input(Image, message);
%
fprintf('\ninitializing ...');
tic
f = 500;
cx = ncol/2;
cy = nrow/2;
K = [f 0 cx;0 f cy;0 0 1];
dh = 0.01;

[x,y,n,Pbase,p1] = get_border(xCoordinates, yCoordinates, K);

hold on;
plot(x,y,'r','linewidth',1);
drawnow;
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);

[temp,s1,s2] = get_surface_patterns(Image,nrow,ncol,x,y);

% find angle
fprintf('\nfinding best angle...');
tic
best_angle = find_angle(Image,x,y,ncol,nrow,n,temp,s1,s2,Pbase,K,p1,dh);
% [lb, ub] = get_range(n, 0, yCoordinates, Pbase, K, p1, nrow, dh);
% best_angle = find_angle(n, Pbase, K, p1, lb, ub, Ix,Iy,FeaturesMatrix, dh);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);


%fit ellipse
fprintf('\nfitting ellipses ...');
tic
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
[~,~,~,~] = plotDome(lb, ub, profile, dh, imgq);
% [im, rep] = find_repeating_pattern(imgq,t);
% new_rgb = smooth_image(im);
% I = imadjust(new_rgb,[.25 .9],[0, 1]);
% plotDome(lb, ub, profile, dh, I, rep);
e = toc;
fprintf('\t\t done! \t Elapsed time: %.2fs \n',e);
end

