function [lb, ub] = get_range(n, ang, Pbase, K, p1, nrow, dh, top_point,bot_point,f)

na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
Rna = axang2rotm([n' ang*pi/180]);
na = Rna*na;

options = optimoptions('fmincon');
options.Display = 'off';
options.MaxFunctionEvaluations = 1000;


lb = fmincon(@(i) Cost(i, Pbase, dh, na, n, K, p1, nrow, bot_point,f,'bot'), ...
    0,[],[],[],[],[],[],[],options);


ub = fmincon(@(i) Cost(i, Pbase, dh, na, n, K, p1, nrow, top_point,f,'top'),...
    lb+20,[],[],[],[],lb,lb + 1000,[],options);


range = ub - lb;
lb = lb + 0.02*range;
ub = ub - 0.02*range;


end