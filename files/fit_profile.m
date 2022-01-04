function [prh, na, a, b] = fit_profile(n, ang, Pbase, K, p1, lb, ub, dh,f)

na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
Rna = axang2rotm([n' ang*pi/180]);
na = Rna*na;
% len = ub - lb;
len = 40;
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
    counter = counter+1;
%     plot3(Points(1,:), Points(2,:), Points(3,:), 'blue');
    hold on;
    plot(qcircle(1,:), qcircle(2,:),'g', 'linewidth',0.5);
    drawnow
end
title('Profile');
% prh = polyfit(h,rh,7);
cs = spline(h,[0 rh 0]);
height = linspace(min(h),max(h),250);
radius = ppval(cs,height);
prh = [height; radius];
end

