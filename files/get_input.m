function [lx,ly,rx,ry,topPoint,R] = get_input(boundaries)


[y,x] = find(boundaries);

x = movmedian(double(x), 5);
y = movmedian(double(y), 5);

while length(x) > 3000
    x = x(1:2:end);
    y = y(1:2:end);
end

CH = bwconvhull(boundaries);
orientation = regionprops(logical(CH), 'Orientation').Orientation;
% if orientation > -95 && orientation < -85
%     orientation = -orientation;
% end

%% get top point
boundaryPoints = [x, y];
% Rotate the boundary points
if orientation < 0
    theta = orientation+90;
else
    theta = orientation-90;
end

R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
rotatedPoints = (R * boundaryPoints')';
% Find the centroid of the rotated points
rotatedCenter = mean(rotatedPoints);
% Find the top point in the rotated coordinate system
[topPointRotated, top_idx] = min(rotatedPoints(:, 2));
% Combine the x-coordinate of the centroid and the y-coordinate of the top point
topPoint = [rotatedCenter(1), topPointRotated];
% Rotate the top point back to the original coordinate system
% topPoint = (R' * topPoint')';

% get bottom point
[botPointRotated, bot_idx] = max(rotatedPoints(:, 2));
botPoint = [rotatedCenter(1), botPointRotated];
% botPoint = (R' * botPoint')';

topPoint = min(topPoint, botPoint);

%%
leftPoints = rotatedPoints(rotatedPoints(:, 1) <= rotatedCenter(1), :);
rightPoints = rotatedPoints(rotatedPoints(:, 1) > rotatedCenter(1), :);

% if orientation<0
%     leftPoints = rotatedPoints(rotatedPoints(:, 1) <= rotatedCenter(1), :);
%     rightPoints = rotatedPoints(rotatedPoints(:, 1) > rotatedCenter(1), :);
% else
%     rightPoints = rotatedPoints(rotatedPoints(:, 1) <= rotatedCenter(1), :);
%     leftPoints = rotatedPoints(rotatedPoints(:, 1) > rotatedCenter(1), :);
% end




lx = leftPoints(:,1)';
ly = leftPoints(:,2)';
rx = flipud(rightPoints(:,1))';
ry = flipud(rightPoints(:,2))';







