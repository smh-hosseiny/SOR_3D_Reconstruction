% function [lb, ub] = get_range(n, ang, Pbase, K, p1, nrow, dh, top_point,bot_point,f,iterations)
% if nargin < 11
%     iterations = 100;
% end
% na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
% Rna = axang2rotm([n' ang*pi/180]);
% na = Rna*na;
% 
% 
% options = optimoptions('fmincon', 'StepTolerance', 1e-10, 'MaxFunctionEvaluations', iterations,...
%     'Display', 'none', 'ConstraintTolerance',1e-10, 'Algorithm','sqp');
% 
% 
% 
% lb = fmincon(@(i) Cost(i, Pbase, dh, na, n, K, p1, nrow, bot_point,f,'bot'), ...
%     0,[],[],[],[],-100,100,[],options);
% 
% 
% ub = fmincon(@(i) Cost(i, Pbase, dh, na, n, K, p1, nrow, top_point,f,'top'),...
%     lb+50,[],[],[],[],lb,lb + 1000,[],options);
% 
% 
% range = ub - lb;
% lb = lb + 0.01*range;
% ub = ub - 0.02*range;
% 
% end

function [lb, ub] = get_range(n, ang, Pbase, K, p1, nrow, dh, top_point, bot_point, f, iterations)
    if nargin < 11
        iterations = 100;
    end
    % Compute 'na' vector
    n_cross_z = cross(n, [0; 0; 1]);
    n_cross_norm = norm(n_cross_z);
    if n_cross_norm == 0
        % 'n' is parallel to z-axis
        na = [1; 0; 0]; % Choose any vector orthogonal to 'n'
    else
        na = n_cross_z / n_cross_norm;
    end
    Rna = axang2rotm([n', ang * pi / 180]);
    na = Rna * na;
    
    % Set optimization options
    options = optimset('TolX', 1e-6, 'MaxFunEvals', iterations, 'Display', 'off');
    
    % Initial guess and bounds for lb
    lb0 = 0;
    lb_lower = -100;
    lb_upper = 100;
    
    % Find the lower bound (lb) using fminsearchbnd
    lb = fminsearchbnd(@(i) Cost(i, Pbase, dh, na, n, K, p1, nrow, bot_point, f, 'bot'), ...
        lb0, lb_lower, lb_upper, options);
    
    % Initial guess and bounds for ub
    ub0 = lb + 50;
    ub_lower = lb;
    ub_upper = lb + 1000;
    
    % Find the upper bound (ub) using fminsearchbnd
    ub = fminsearchbnd(@(i) Cost(i, Pbase, dh, na, n, K, p1, nrow, top_point, f, 'top'), ...
        ub0, ub_lower, ub_upper, options);
    
    % Adjust lb and ub slightly to avoid edge effects
    range = ub - lb;
    lb = lb + 0.01 * range;
    ub = ub - 0.02 * range;
end