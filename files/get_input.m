function [symmetry_angle,mask,lx,ly,rx,ry,topPoint,R] = get_input(mask)


% boundaries = bwperim(mask);
% [y,x] = find(boundaries);
[y, x] = get_mask_boundary(mask);

% x = movmedian(double(x), 5);
% y = movmedian(double(y), 5);

while length(x) > 3000
    x = x(1:2:end);
    y = y(1:2:end);
end

% find symmetry angle
symmetry_angle1 = regionprops(logical(mask), 'Orientation').Orientation;
if symmetry_angle1 < 0
    symmetry_angle1 = symmetry_angle1+90;
else
    symmetry_angle1 = symmetry_angle1-90;
end

symmetry_angle = find_symmetry_axis_reflection(logical(mask));

if abs(symmetry_angle1 - symmetry_angle) > 45
    symmetry_angle = symmetry_angle1;
end

%% get top point
boundaryPoints = [x, y];
theta = symmetry_angle;




R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
% R = [cosd(theta), sind(theta); sind(theta), -cosd(theta)];
rotatedPoints = (R * boundaryPoints')';

% Find the centroid of the rotated points
rotatedCenter = mean(rotatedPoints);
% Find the top point in the rotated coordinate system
[topPointRotated, top_idx] = min(rotatedPoints(:, 2));
% Combine the x-coordinate of the centroid and the y-coordinate of the top point
topPoint = [rotatedPoints(top_idx, 1), topPointRotated];
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


%%


rotated_p2 = (R' * [y, x]')';

x_rotated = rotated_p2(:,2);
y_rotated = rotated_p2(:,1);

% Shift coordinates to ensure all are positive
min_x = min(x_rotated);
min_y = min(y_rotated);

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

x_rotated = x_rotated + shift_x;
y_rotated = y_rotated + shift_y;

m = ceil(max(abs(y_rotated))) + 20; % Number of rows (height)
n = ceil(max(abs(x_rotated))) + 20; % Number of columns (width)

% Create binary mask using poly2mask
mask = poly2mask(x_rotated, y_rotated, m, n);

end







