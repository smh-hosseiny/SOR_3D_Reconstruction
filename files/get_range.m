function [lb, ub] = get_range(n, ang, Pbase, K, p1, dh, top_point, bot_point, f,y,mask, iterations)
    if nargin < 14
        iterations = 100;
    end
    % Compute 'na' vector
    n_cross_z = cross(n, [0; 0; 1]);
    n_cross_norm = norm(n_cross_z);
    if n_cross_norm == 0
        na = [1; 0; 0]; 
    else
        na = n_cross_z / n_cross_norm;
    end
    Rna = axang2rotm([n', ang * pi / 180]);
    na = Rna * na;
    
    options = optimset('TolX', 1e-8, 'MaxFunEvals', iterations, 'Display', 'off');
    
    % Initial guess and bounds for lb
    lb0 = 0;
    lb_lower = -100;
    lb_upper = 100;
    
    % Find the lower bound (lb) using fminsearchbnd
    lb = fminsearchbnd(@(i) Cost(i, Pbase, dh, na, n, K, p1, bot_point, f, 'bot',bot_point,y,mask), ...
        lb0, lb_lower, lb_upper, options);
    
    % Initial guess and bounds for ub
    ub0 = lb + 50;
    ub_lower = lb+1;
    ub_upper = lb + 1000;
    
    % Find the upper bound (ub) using fminsearchbnd
    ub = fminsearchbnd(@(i) Cost(i, Pbase, dh, na, n, K, p1, top_point, f,'top',bot_point,y,mask), ...
        ub0, ub_lower, ub_upper, options);
    

    % Adjust lb and ub slightly to avoid edge effects
    range = ub - lb;
    lb = lb + 0.01 * range;
    ub = ub - 0.01 * range;
end