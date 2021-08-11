function best_angle = find_angle(Image,x,y,ncol,nrow,n,temp,s1,s2,Pbase, K, p1, dh)
angle = -2:4:40;
start = 35/100;
finish = 65/100;
r1 = min(x)/ncol * 180;
r2 = max(x)/ncol * 180;
score1 = [];
refrence = temp(:, round(s2*start):round(s2*finish),:);
for ang = angle
    [lb, ub] = get_range(n, ang, x,y, Pbase, K, p1, nrow, dh);
    I = surface_projection(Image,r1,r2, n, Pbase, K, p1, lb, ub, dh, s1, s2,ang); 
    I = flip(I,2);
    s = ssim(I(:, round(s2*start):round(s2*finish),:), refrence);
    score1 = [score1, s];
end

[~, idx1] = max(score1);
best_angle = angle(idx1);
% d = ub - lb;
% indices = floor(linspace(floor(lb + 0.2*d), floor(ub - 0.2*d), 4));
% angle_range = (10:4:42);
% costs = ones(1,length(angle_range));
% for idx = indices
%     for i=1:length(angle_range)
%         ang = angle_range(i);
%         na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
%         Rna = axang2rotm([n' ang*pi/180]);
%         na = Rna*na;
%         circle(1).center = Pbase + idx*dh*na;
%         circle(1).normal = na;
%         j = 0:360;
%         a = n;
%         b = cross(a,circle(1).normal);
%         for r = .01:.001:0.8
%             circle(1).radius = r;
%             circle(1).Points = circle(1).center + circle(1).radius*(a*cosd(j)+b*sind(j));
%             qcircle = K*[circle(1).Points];
%             qcircle = qcircle./repmat(qcircle(3,:),3,1);
%             xm = get_rval(p1,qcircle(2,:));
%             if sum(qcircle(1,:)<xm) > 0
%                 break;
%             end
%         end
%         cost = get_score(qcircle(1,:), qcircle(2,:),Ix,Iy,FeaturesMatrix);
%         costs(i) = costs(i) + cost;
%     end
% end
% 
% 
% best_angle = angle_range(costs == min(costs));

end

