function [x_border ,y_border ,n,Pbase,p1,top_point,best_theta,best_phi] = get_border(xCoordinates, yCoordinates,nrow, ncol,K)

% Iniitialize
[i, top_point]  = get_top(xCoordinates, yCoordinates,nrow, ncol);

warning off

[lx,ly,rx,ry] = resample_border(xCoordinates, yCoordinates,i,250);
% [ly,lx] = splineInterp(ly, lx);
% [ry,rx] = splineInterp(ry, rx);

theta = linspace(0,pi,20); 
phi = linspace(0,2*pi,40);  %list of places to search for first parameter       %list of places to search for second parameter
[F,S] = ndgrid(theta, phi);
fitresult = arrayfun(@(p1,p2) fittingfunction(p1,p2,lx,ly,rx,ry,K), F, S); %run a fitting on every pair fittingfunction(F(J,K), S(J,K))
[~, minidx] = min(fitresult);
best_theta = mean(F(minidx));
best_phi = mean(S(minidx));


x_border = [lx, rx];
y_border = [ly, ry];

% find symmetric line
n = [best_theta best_phi];
max_iter = 3;
for iter=1:max_iter
%     fprintf('\t iter \t',iter);
    n = find_plane(lx,rx,ly,ry,K,n);
    [~, idx] = min(vecnorm([x_border;y_border] - [top_point(1);top_point(2)], 2,1));
    [lx,ly,rx,ry] = resample_border(x_border,y_border,idx,250);
    [xs,ys,top_point] = get_symm_line(lx,ly,x_border,y_border,n,K);
end
n = [sin(n(1)) * cos(n(2));
    sin(n(1)) * sin(n(2));
    cos(n(1))];
% n = [cos(n(1))*sin(n(2));sin(n(1));cos(n(1))*cos(n(2))];
n = n/norm(n);

plot(xs, ys, '--','color', 'c', 'linewidth',2);
Pbase = K\[xs(1);ys(1);1];


p1 = [];
for i=1:idx
    [lxInter, lyInter] = project(x_border(i),y_border(i),n,K);
    l_radius = norm([x_border(i), y_border(i)]-[lxInter, lyInter]);
    p1 = [p1, [lyInter; l_radius; y_border(i); x_border(i)]];  
end
valid_idx = diff(p1(1,:))~=0;
p1 = p1(:,valid_idx);

end


function [xIntersection, yIntersection] = project(x0,y0,n,K)
Ps = K\[x0;y0;1];
Qs = Ps-Ps'*n*n;
qs = K*Qs./Qs(3,:);
xIntersection = qs(1);
yIntersection = qs(2);
% ps = -1/m;
% yInt = -ps * x0 + y0;
% xIntersection = (yInt - b) / (m - ps);
% yIntersection = ps * xIntersection + yInt;
end
