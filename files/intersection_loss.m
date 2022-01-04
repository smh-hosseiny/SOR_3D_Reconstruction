function [loss] = intersection_loss(rx,ry,p)

[~,idx] = min(vecnorm([rx;ry]-p));
loss = norm([rx(idx);ry(idx)] - p);
end