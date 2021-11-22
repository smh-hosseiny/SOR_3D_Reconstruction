function cost = evaluate_fitness(x,y,px,py,nrow,top_point,side)
if strcmp(side, 'upper')
cost = min(vecnorm([px;py]-[top_point(1);top_point(2)],1,1));
% cost = norm([px(1);py(1)] - [top_point(1);top_point(2)]);
%       cost = abs(top_point(1) - min(py)) + heaviside(top_point(1) - min(py)) * 100;
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
