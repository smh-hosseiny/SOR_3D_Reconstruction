function cost = evaluate_fitness(x,y,px,py,nrow,extremum,side)
if strcmp(side, 'top')
    [min_y, idx] = min(py);
    point = [px(idx); min_y];
    cost = mean(vecnorm([x;y]-point)) + norm(extremum(2) - min_y);
    if min_y < extremum(2)
        cost = cost + 1e7*(extremum(2) - min_y);
    end


else   
    [max_y, idx] = max(py);
    point = [px(idx); max_y];
    cost = mean(vecnorm([x;y]-point)) + norm(extremum(2) - max_y);
    if max_y > extremum(2)
        cost = cost + 1e7*(max_y - extremum(2));
    end
   
end

    % [~,idx] = min(vecnorm([x;y]-[extremum(1);extremum(2)]));
    % points = [x(max(1,idx-5):min(length(x),idx+5)); y(max(1,idx-5):min(length(x),idx+5))];
    % cost = 0;
    % for i=1:length(points)
    %     distances = vecnorm([px;py]-points(:,i),2,1);
    %     cost = cost + mean(distances) + 2*min(distances);
    % end

   
% end

end
