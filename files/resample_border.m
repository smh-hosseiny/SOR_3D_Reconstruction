function [lx,ly,rx,ry] = resample_border(x,y,i,N)
lx = x(1:i); ly = y(1:i);
rx = x(i:end); ry = y(i:end);

[rx, ry] = resample(rx,ry,N);
[lx, ly] = resample(lx,ly,N);

  
end

function [nx, ny] = resample(x,y,N)
ny = interp1(1:length(y), y, linspace(1, length(y), N));
nx = interp1(1:length(x), x, linspace(1, length(x), N));
end
