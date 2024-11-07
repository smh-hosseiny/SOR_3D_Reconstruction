function [interp_rgb, status] = surface_projection(Image,ref,R,n,Pbase,K,p1,lb,ub, ...
    dh,bot_point,ang,f,x_boundary,y_boundary,region_mask,symmetry_angle)
% fig = figure('visible','off');
status = 0;
[row, col] = size(Image);
na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
Rna = axang2rotm([n' ang*pi/180]);
na = Rna*na;
N = 64;
rh = zeros(1,N);
h = zeros(1,N);
a = n;
b = cross(a,na);
counter = 1;


for i = linspace(lb,ub,N)
    center = Pbase + i*dh*na;
    radius = find_radius(K, p1, center, a, b,f,region_mask);
    h(counter) = i*dh;
    rh(counter) = radius;
    counter = counter+1;
end

[~, idx] = unique(h);

if length(idx) < 2 
    interp_rgb = [];
    status = 1;
    return 
end

if abs(min(h) - max(h)) < 0.01
    height = linspace(min(h), max(h)+ rand(1)*1e-1, 20);
else
    height = linspace(min(h), max(h), 20);
end

cs = spline(h(idx),[0 rh(idx) 0]);
radius = ppval(cs,height);

%% find the theta range
size_ = 128;

% hq = lb * dh;
% rq = interp1(height,radius,hq,'linear');
% Points = (Pbase + hq*na + rq*(a*cosd(1:60:360)+b*sind(1:60:360)));
% qcircle = K*Points;
% qcircle = bsxfun(@rdivide, qcircle, qcircle(3,:));
% qcircle = R' * qcircle(1:2,:);

% [~, idx] = min(vecnorm([qcircle(1,:); qcircle(2,:)] - (R'*bot_point')));
% if idx < 180
%     th = linspace(0,180,size_);
% else
%     th = linspace(180,360,size_);
% end

th = linspace(0,360,2*size_);

Image_reshaped = reshape(Image, [], 3); % (Height*Width) x 3
surface_patterns = double(zeros(size(Image_reshaped)));


 % fron mask
i = lb + 0.25*(ub-lb);
hq = i*dh;
rq = interp1(height,radius,hq,'linear');
Points = (Pbase + hq*na + rq*(a*cosd(th)+b*sind(th)));
qcircle = K*Points;
qcircle = bsxfun(@rdivide, qcircle, qcircle(3,:));
[~, idx] = min(vecnorm([qcircle(1,:); qcircle(2,:)] - bot_point'));
if idx < size_ || symmetry_angle < 0
    front_angle = 1:size_;
else
    front_angle = size_+1:2*size_;
end


cnt = 1;
h = linspace(lb*dh,ub*dh,size_);
for hq = h
    rq = interp1(height,radius,hq,'linear');
    Points = (Pbase + hq*na + rq*(a*cosd(th)+b*sind(th)));
    qcircle = K*Points;
    qcircle = bsxfun(@rdivide, qcircle, qcircle(3,:));

    % Projected x and y coordinates
    % x_proj = qcircle(1, front_angle);
    % y_proj = qcircle(2, front_angle);
    % Use inpolygon to find points within the boundary
    % [in, ~] = inpolygon(x_proj, y_proj, x_boundary, y_boundary);
    % theta_indices = find(in);
    % 
    % % Skip if no points are within the boundary
    % if isempty(theta_indices)
    %     theta_indices = 1:size_;
    %     % counter = counter + 1;
    %     % continue;
    % end
    
    theta_indices = 1:size_;
    rotated_p = R' * qcircle(1:2, front_angle(theta_indices));
    q = rotated_p;
    % Get indices for image extraction
    y_ind = get_idx(q, 2, 1:length(theta_indices), size(Image,1));
    x_ind = get_idx(q, 1, 1:length(theta_indices), size(Image,2));

    lin = sub2ind(size(Image, [1,2]), y_ind, x_ind);
    
    patterns_ = Image_reshaped(lin, :); % N x 3 matrix  
    % Assign RGB values
    surface_patterns(lin, :) = patterns_;
    cnt = cnt+1;
end
%%

interp_rgb = reshape(surface_patterns, size(Image));

% interp_rgb(interp_rgb ==0) = nan;
% mask_ = all(Image > 1, 3);
% channel = fillmissing(interp_rgb, 'nearest');
% interp_rgb = channel .* mask_;


% interp_rgb = flipud((imresize(surface_patterns, size(ref,[1,2]))));




end
