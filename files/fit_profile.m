function [prh, na, a, b] = fit_profile(n, ang, Pbase, K, p1, lb, ub, dh)

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
    qc = K*center;
    qc = qc./qc(3,:);
%     plot(qc(1),qc(2),'r.');
    [radius,~,~] = get_rval(p1,qc(2));
    radius = radius/1000;
    Points = center + radius*(a*cosd(j)+b*sind(j));
    qcircle = K*Points;
    qcircle = qcircle./repmat(qcircle(3,:),3,1);
%     iter = 0;
%     [~,xm,~] = get_rval(p1,qcircle(2,:));
%     while (sum(qcircle(1,:)<xm, 'all') > 1 && (iter<50))
%         radius = radius - 0.0001;
%         Points = center + radius*(a*cosd(j)+b*sind(j));
%         qcircle = K*Points;
%         qcircle = qcircle./repmat(qcircle(3,:),3,1);
%         [~,xm,~] = get_rval(p1,qcircle(2,:));
%         iter = iter + 1;
%     end
    
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

