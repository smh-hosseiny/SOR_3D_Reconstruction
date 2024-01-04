function [losses] = intersection_loss(rx, ry, points)
    losses = 0;
    for j=1:size(points(2))
        [~, idx] = min(vecnorm([rx; ry] - points(:,j)));
        losses = losses + vecnorm([rx(idx); ry(idx)] - points(:,j));
    end
end
