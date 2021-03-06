function [lb, ub] = get_range(n, ang, Pbase, K, p1, nrow, dh, top_point,f)

na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
Rna = axang2rotm([n' ang*pi/180]);
na = Rna*na;

options = optimoptions('fmincon');
options.Display = 'off';
options.MaxFunctionEvaluations = 1000;
lb = fmincon(@(i) Cost(i, Pbase, dh, na, n, K, p1, nrow, top_point,'lower',f), ...
    0,[],[],[],[],[],[],[],options);


options2 = optimoptions('fmincon');
options2.Display = 'off';
options2.MaxFunctionEvaluations = 1250;
ub = fmincon(@(i) Cost(i, Pbase, dh, na, n, K, p1, nrow, top_point,'upper',f),...
    lb,[],[],[],[],[],[],[],options2);

end