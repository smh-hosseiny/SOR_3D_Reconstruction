function [lb, ub] = get_range(n, ang, Pbase, K, p1, nrow, dh, top_point,bot_point,f,iterations)
if nargin < 11
    iterations = 100;
end
na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
Rna = axang2rotm([n' ang*pi/180]);
na = Rna*na;


options = optimoptions('fmincon', 'StepTolerance', 1e-10, 'MaxFunctionEvaluations', iterations,...
    'Display', 'none', 'ConstraintTolerance',1e-10, 'Algorithm','sqp');



lb = fmincon(@(i) Cost(i, Pbase, dh, na, n, K, p1, nrow, bot_point,f,'bot'), ...
    0,[],[],[],[],-100,100,[],options);


ub = fmincon(@(i) Cost(i, Pbase, dh, na, n, K, p1, nrow, top_point,f,'top'),...
    lb+50,[],[],[],[],lb,lb + 1000,[],options);


range = ub - lb;
lb = lb + 0.02*range;
ub = ub - 0.02*range;


end