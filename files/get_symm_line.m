function [xs,ys,topPoint,botPoint] = get_symm_line(x_border,y_border,n,K)
N = length(x_border);
qsa = zeros(2,N);
k = 0;
n = [sin(n(1)) * cos(n(2));
    sin(n(1)) * sin(n(2));
    cos(n(1))];
% [cos(n(1))*sin(n(2));sin(n(1));cos(n(1))*cos(n(2))];
n = n/norm(n);

for i = 1:N
    k = k + 1;
    ps = [x_border(i);y_border(i)];
    Ps = K\[ps;1];
    Qs = Ps-Ps'*n*n;
    qs = K*Qs./Qs(3,:);
    qsa(:,k) = qs(1:2);
end

% plot(qsa(1,:), qsa(2,:), 'ko', 'linewidth',2);

xs = qsa(1,:);
ys = qsa(2,:);

[min_y, idx] = min(qsa(2,:));
[max_y, idx2] = max(qsa(2,:));
topPoint = [qsa(1,idx), min_y];
botPoint = [qsa(1,idx2), max_y];

% pa = polyfit(qsa(2,:),qsa(1,:),1);
% yy = linspace(0,max(y_border),10);
% xx = polyval(pa,yy);
% X = InterX([x_border;y_border],[xx;yy]);
% X2 = InterX([[x_border(1), x_border(end)];[y_border(1), y_border(end)]],[xx;yy]);
% 
% if ~isempty(X2)
%     y1= X(2,1);
%     y2 = X2(2,end);
%     ys = [y2 y1];
%     xs = polyval(pa,ys);
%     top_point = [xs(1), ys(1)];
% else
%     top_point = [lx(1), ly(1)];
%     xs = [];
%     ys = [];    
% end

% slope = (xs(end)-xs(1)) / (ys(end)-ys(1));
% slope = -1/slope;
% symmetryLineCoefficients = polyfit(qsa(2,:), qsa(1,:), 1);
% slope = symmetryLineCoefficients(1);
% theta = atand(slope)
% boundaryPoints = [x_border; y_border];
% % Rotate the boundary points
% R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
% rotatedPoints = (R * boundaryPoints);
% rotatedCenter = mean(rotatedPoints, 2);
% [topPointRotated, top_idx] = min(rotatedPoints(:, 2));
% topPoint = [rotatedCenter(1), topPointRotated];
% topPoint = (R' * topPoint')';
% [botPointRotated, bot_idx] = max(rotatedPoints(:, 2));
% botPoint = [rotatedCenter(1), botPointRotated];
% botPoint = (R' * botPoint')';
% xs = [botPoint(1) topPoint(1)];
% ys = [botPoint(2) topPoint(2)];

% % Find the y-coordinates on the symmetry line for all boundary points
% symmetryLineYValues = polyval(symmetryLineCoefficients, unique(x_border));
% % Find the point with the maximum y-coordinate on the symmetry line
% [maxSymmetryLineY, idx] = min(symmetryLineYValues);
% top_point = [qsa(1,idx), maxSymmetryLineY];
% [minSymmetryLineY, idx] = max(symmetryLineYValues);
% bot_point = [qsa(1,idx), minSymmetryLineY];


end

