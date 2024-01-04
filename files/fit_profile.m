function [prh, na, a, b, front_angle] = fit_profile(n, ang, Pbase, K, p1, lb, ub, dh,f,bot_point,R)

na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
Rna = axang2rotm([n' ang*pi/180]);
na = Rna*na;
% len = ub - lb;
len = 100;
rh = zeros(1, len);
h = zeros(1, len);

counter = 1;
for i = linspace(lb,ub,len)
    center = Pbase + i*dh*na;
    j = 0:360;
    a = n;
    b = cross(a,na);
    radius = find_radius(K, p1, center, a, b,f);
    Points = center + radius*(a*cosd(j)+b*sind(j));
    qcircle = K*Points;
    qcircle = qcircle./repmat(qcircle(3,:),3,1);
    
    h(counter) = i*dh;
    rh(counter) = radius;
    rotated_p = R' * qcircle(1:2,:);
%     plot3(Points(1,:), Points(2,:), Points(3,:), 'blue');
    hold on;
    if rem(counter,2) == 0
        plot(rotated_p(1,:), rotated_p(2,:),'g', 'linewidth',0.5);
        drawnow
    end
    if i==lb
        [~, idx] = min(vecnorm([qcircle(1,:); qcircle(2,:)] - bot_point'));
        if idx < 180
            front_angle = 0:0.1:180;
        else
            front_angle = 180:0.1:360;
        end
    end

    counter = counter+1;
end
title('Profile');
% prh = polyfit(h,rh,7);
[~, idx] = unique(h);
if length(idx) < 2
    prh = [h; rh];
    return 
end
cs = spline(h,[0 rh 0]);
height = linspace(min(h),max(h),250);
radius = ppval(cs,height);
prh = [height; radius];
end

