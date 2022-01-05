function cost = evaluate_fitness(x,y,px,py,nrow,top_point,side)
if strcmp(side, 'upper')
   [~,idx] = min(vecnorm([x;y]-[top_point(1);top_point(2)]));
    points = [x(idx-5:min(length(x),idx+5)); y(idx-5:min(length(x),idx+5))];
    cost = 0;
    for i=1:length(points)
        distances = vecnorm([px;py]-points(:,i),2,1);
        cost = cost + mean(distances)+ 1.1*min(distances);
    end
% cost = norm([px(1);py(1)] - [top_point(1);top_point(2)]);
else
    bottom_left_x = x(1);
    bottom_left_y = y(1);
    cost = min(vecnorm([px;py]-[bottom_left_x; bottom_left_y],1,1));
%     cost = norm([bottom_left_x; bottom_left_y] - [px(1); py(1)]);
    if max(py) > nrow
        cost = cost + 1e10*(max(py) - nrow);
    end
end

end
