function cost = evaluate_fitness(x,y,px,py,nrow,side)
    if strcmp(side, 'upper')
        cost = abs(min(py) - 1.05*min(y));
    else
%         [~, my] = min(y);
%         y_left = y(1:my);
        bottom_left_x = x(1);
        bottom_left_y = y(1);
        
        [minx, ix] = min(px);
        cost = norm([bottom_left_x, bottom_left_y] - [minx, py(ix)]);
%         cost = abs(border_max_y - py(ix));
%         cost = cost + abs(border_min_x - minx);
        if max(py) > nrow
            cost = cost + 1e10*(max(py) - nrow);
        end
%         cost = cost + 1e2*(max(py) - nrow + abs((max(py) - nrow)));
    end

end
