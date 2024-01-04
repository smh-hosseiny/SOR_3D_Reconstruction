function [nx,ny] = resample_border(x,y,N)

if length(x) > 2 && length(y) > 2
    ny = interp1(1:length(y), y, linspace(1, length(y), N), "spline");
    nx = interp1(1:length(x), x, linspace(1, length(x), N), "spline");
end

end