function [losses] = intersection_loss(x, y, points)
    losses = 0;
    for j=1:size(points,2)
        [~, idx] = min(vecnorm([x; y] - points(:,j)));
        losses = losses + vecnorm([x(idx); y(idx)] - points(:,j));
    end
end
