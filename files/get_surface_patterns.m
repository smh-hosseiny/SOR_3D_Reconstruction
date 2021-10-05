function [sub,s1,s2] = get_surface_patterns(Image,nrow,ncol,x,y,K,n)

h = max(y) - min(y);
if max(y)/nrow < 0.9
    [nx, ny] = extrapolate_border(x,y,nrow,K,n,h);
else
    nx = x; ny = y;
end

mask = poly2mask(nx, ny, nrow, ncol);
I = bsxfun(@times, Image, cast(mask, 'like', Image));

minx = min(x);
maxx = max(x);
miny = min(y);
maxy = min(max(y)+0.05*h, nrow);
sub=imcrop(I,round([minx miny maxx-minx maxy-miny]));
s1 = size(sub,1); s2=size(sub,2);
end


function [nx, ny] = extrapolate_border(x,y,nrow,K,n,h)

[~, i] = min(y);
lx = x(1:i); ly = y(1:i);
[~, idx] = min(ly - min(y)+round(0.075 * h));
yd = fliplr(ly(1:idx));
xd = fliplr(lx(1:idx));

p = polyfit(yd,xd,3);
range = linspace(yd(end), min(yd(end)+0.05*(h), nrow), 10);
nx = polyval(p, range);

xd = [xd, mean([xd(end),nx(1)]), nx];
yd = [yd, mean([yd(end),range(1)]), range];
valid = xd < x(i);
xd = xd(valid);
yd = yd(valid);

new_lx = [fliplr(xd), lx(idx+1:end)];
new_ly = [fliplr(yd), ly(idx+1:end)];

[new_rx,new_ry] = project_border(nx, range);

new_rx = [x(i+1:end), mean([x(end),new_rx(1)]), new_rx];
new_ry = [y(i+1:end), mean([y(end),new_ry(1)]), new_ry];

nx = [new_lx, new_rx];
ny = [new_ly, new_ry];

function [new_rx,new_ry] = project_border(new_x, new_y)
new_rx = [];
new_ry = [];
for j = 1:length(new_y)
    ps = [new_x(j); new_y(j)];
    Ps = K\[ps;1];
    Qs = Ps-2*Ps'*n*n;
    qs = K*Qs./Qs(3,:);
    new_rx = [new_rx, qs(1)];
    new_ry = [new_ry, qs(2)];
end
end

end



