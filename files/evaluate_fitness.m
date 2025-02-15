function cost = evaluate_fitness(x,y,px,py,mask,extremum,side)
        

    [min_x, idx] = min(px);
    point = [min_x; py(idx)];
    min_distance = min(vecnorm([x;y]-point));

    if strcmp(side, 'top')
        [min_y, ~] = min(py);
        penalty_deviation = abs(extremum(2) - min_y);          

    else   
        [max_y, ~] = max(py);
        penalty_deviation = abs(max_y - extremum(2));
         
    end
    
    % penalty_alignment
    mean_py_val = mean(py);
    delta_y = 2; 
    y_close_mask = abs(y - mean_py_val) < delta_y;
    x_close = x(y_close_mask);
    
    if isempty(x_close)
        penalty_alignment = 0;
    else
        ellipse_left = min(px);
        ellipse_right = max(px);
        distances = min(abs(x_close - ellipse_left), abs(x_close - ellipse_right));
        penalty_alignment = mean(distances);
    end

    % Step 4: outside penalty
    min_x = min(x);
    min_y = min(y);
    if min_x <= 0
        shift_x = abs(min_x) + 1; % Shift to make min(x) = 1
    else
        shift_x = 0;
    end
    
    if min_y <= 0
        shift_y = abs(min_y) + 1; % Shift to make min(y) = 1
    else
        shift_y = 0;
    end
    
    % Apply shifts
    px = px + shift_x;
    py = py + shift_y;
    
    idx = sub2ind(size(mask), min(max(1,round(py)), size(mask,1)), ...
        min(max(1,round(px)),  size(mask,2)) );
    penalty_outside = sum(~mask(idx)); 
  
    % Total Cost Calculation
    cost =1e1*min_distance + 2.5e1*penalty_deviation + 2*penalty_outside + 2e1*penalty_alignment;


end
