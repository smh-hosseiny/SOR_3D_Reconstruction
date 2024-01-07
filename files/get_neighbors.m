function n = get_neighbors(x, y, points)
    n = [];
    for j=1:size(points,2)
        [h, idx] = min(vecnorm(y - points(2,j), 2, 1));
        n = [n, [x(idx); y(idx)]];
        
    end
end