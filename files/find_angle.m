function best_angle = find_angle(nrow,n,reference,Pbase,K,p1,dh,top_point,bot_point,f,R)


% initialAngle = 0;
% nvars = 1;
% lb = -5;
% ub = 5;
% costFunction = @(ang) computeVisualLoss(ang, n, Pbase, K, p1, nrow, dh, top_point, f, Image, reference);

% Set up optimization options
% options = optimset('fmincon');
% options = optimset(options, 'Display', 'iter', ...
%     'MaxIter', 30, 'TolX', 1e-9, 'MaxFunEvals', 100, 'TolFun', 1e-2);
% [best_angle, ~] = fmincon(costFunction, initialAngle, [], [], [], [], lb, ub, [], options);

% options = optimoptions('ga', 'ConstraintTolerance', 0.1, 'MaxTime', 10, ...
%     'MaxGenerations', 10, 'PopulationSize', 15);
% best_angle = ga(costFunction, nvars, [], [], [], [], lb, ub, [], options);


% options = saoptimset('Display', 'None', 'TolFun', 1e-3, 'MaxIter', 40);
% [best_angle, ~] = simulannealbnd(costFunction, initialAngle, lb, ub, options);

top_point = (R' * top_point')';
bot_point = (R' * bot_point')';
p = R' * [p1(4,:); p1(3,:)];
p1(3,:) = p(2,:);
p1(4,:) = p(1,:);
p = R' * [p1(1:2,:)];
p1(1,:) = p(1,:);

R_3d = eye(3);
R_3d(1:2, 1:2) = R;
Pbase = R_3d' * Pbase;
n = R_3d' * n;


angles = -20:10:30;
score = [];
% idx1 = 1:s1;
% round(1*s1/10:9*s1/10);
% idx2 = 1:s2;
% round(2*s2/10:8*s2/10);
for ang = angles
    l = computeVisualLoss(ang, n, Pbase, K, p1, nrow, dh, top_point, bot_point, f, reference);
    score = [score, l];
end

[hs, idx] = min(score);
ba = angles(idx);

% stage 2

score2 = [];
phase_2_angle = [ba-4, ba-2, ba+2, ba+4];
for ang = phase_2_angle
    l = computeVisualLoss(ang, n, Pbase, K, p1, nrow, dh, top_point, bot_point, f, reference);
    score2 = [score2, l];
end

[hs2, idx2] = min(score2);
ba2 = phase_2_angle(idx2);

if hs2 < hs
    best_angle = ba2;
else
    best_angle = ba;
end

% Function to compute similarity metric for a given rotation angle
