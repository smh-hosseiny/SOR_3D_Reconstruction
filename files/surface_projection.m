function [interp_rgb, status] = surface_projection(Image,ref,R,n,Pbase,K,p1,lb,ub,dh,bot_point,ang,f)
% fig = figure('visible','off');
status = 0;
[row col] = size(Image);
na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
Rna = axang2rotm([n' ang*pi/180]);
na = Rna*na;
N = 32;
rh = zeros(1,N);
h = zeros(1,N);
a = n;
b = cross(a,na);
counter = 1;


for i = linspace(lb,ub,N)
    center = Pbase + i*dh*na;
    radius = find_radius(K, p1, center, a, b,f);
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

if abs(min(h) - max(h)) < 0.1
    height = linspace(min(h), max(h)+ rand(1)*1e-1, 20);
else
    height = linspace(min(h), max(h), 20);
end

cs = spline(h(idx),[0 rh(idx) 0]);
radius = ppval(cs,height);

% find the theta range
size_ = 64;

hq = lb * dh;

rq = interp1(height,radius,hq,'linear');
Points = (Pbase + hq*na + rq*(a*cosd(1:60:360)+b*sind(1:60:360)));
qcircle = K*Points;
qcircle = bsxfun(@rdivide, qcircle, qcircle(3,:));
qcircle = R' * qcircle(1:2,:);
[~, idx] = min(vecnorm([qcircle(1,:); qcircle(2,:)] - (R'*bot_point')));
if idx < 180
    th = linspace(0,180,size_);
else
    th = linspace(180,360,size_);
end
 

surface_patterns = double(zeros(size_,size_));
cnt = 1;
h = linspace(lb*dh,ub*dh,size_);
for hq = h
    rq = interp1(height,radius,hq,'linear');
    Points = (Pbase + hq*na + rq*(a*cosd(th)+b*sind(th)));
    qcircle = K*Points;
    qcircle = bsxfun(@rdivide, qcircle, qcircle(3,:));
    qcircle = R' * qcircle(1:2,:);
    % plot(qcircle(1,:), qcircle(2,:),'g', 'linewidth',0.5);
    y_ind = get_idx(qcircle, 2, 1:size_, row);
    x_ind = get_idx(qcircle, 1, 1:size_, col);
    lin = sub2ind(size(Image), y_ind, x_ind);
    surface_patterns(cnt, 1:size_) = Image(lin);
    cnt = cnt+1;
end



interp_rgb = flipud((imresize(surface_patterns, size(ref,[1,2]))));




end
