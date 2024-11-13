function [x_border,y_border,n,Pbase,p1,top_point,bot_point,xs,ys] = get_border(lx,ly,rx,ry,top_point,K,R)

warning off


theta = linspace(0,pi,20); 
phi = linspace(0,2*pi,40);    
[F,S] = ndgrid(theta, phi);
fitresult = arrayfun(@(p1,p2) fittingfunction(p1,p2,top_point(1),top_point(2),top_point(1),top_point(2),K), F, S); 
[~, minidx] = min(fitresult);
best_theta = mean(F(minidx));
best_phi = mean(S(minidx));


x_border = [lx, rx];
y_border = [ly, ry];


% find symmetric line
n = [best_theta best_phi];
max_iter = 3;
for iter=1:max_iter
    n = find_plane(lx,rx,ly,ry,K,n);
    [xs,ys,top_point,bot_point] = get_symm_line(lx,ly,n,K);
    [xs,ys] = resample_border(xs,ys,length(lx));
    
end
n = [sin(n(1)) * cos(n(2));
    sin(n(1)) * sin(n(2));
    cos(n(1))];

n = n/norm(n);

Pbase = K\[xs(1);ys(1);1];
p1 = [ys; vecnorm([xs;ys] - [lx;ly], 2, 1); ly; lx];


% Remove points with repeated y-values
[~, unique_idx, ~] = unique(p1(1, :));
p1 = p1(:, unique_idx);

end