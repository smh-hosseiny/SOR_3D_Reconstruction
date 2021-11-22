
function [lb, ub] = get_range(n, ang, Pbase, K, p1, nrow, dh, top_point)

na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
Rna = axang2rotm([n' ang*pi/180]);
na = Rna*na;

options = optimoptions('fmincon');
options.Display = 'off';
options.MaxFunctionEvaluations = 500;
lb = fmincon(@(i) Cost(i, Pbase, dh, na, n, K, p1, nrow, top_point,'lower'), ...
    0,[],[],[],[],[],[],[],options);


options2 = optimoptions('fmincon');
options2.Display = 'off';
options2.MaxFunctionEvaluations = 1250;
ub = fmincon(@(i) Cost(i, Pbase, dh, na, n, K, p1, nrow, top_point,'upper'),...
    lb,[],[],[],[],[],[],[],options2);

% ub_range = lb+1:lb+70;
% c = [];
% for u = ub_range
%    c = [c,  Cost(u, Pbase, dh, na, n, K, p1, x,y, nrow, 'upper')]; 
% end
% [~, i] = min(c);
% ub = ub_range(i);


% Min = min(y);
% Max  = max(y);
% 
% 
% lb = []; ub = [];
% for i = 1:1:100
%     circle(i).center = Pbase + (i-1)*dh*na;
%     circle(i).normal = na;
%     j = 0:360;
%     a = n;
%     b = cross(a,circle(1).normal);
%     for r = .01:.001:1
%         circle(i).radius = r;
%         circle(i).Points = circle(i).center + circle(i).radius*(a*cosd(j)+b*sind(j));
%         qcircle = K*[circle(i).Points];
%         qcircle = qcircle./repmat(qcircle(3,:),3,1);
%         xm = get_rval(p1,qcircle(2,:));
%         if sum(qcircle(1,:)<xm) > 0
%             break;
%         end
%     end
%     if round(0.98*Min) <= min(qcircle(2,:)) && min(qcircle(2,:)) <= round(4 * Min)
%         ub = [ub, i];    
% 
%     elseif  max(qcircle(2,:)) < nrow &&  round(Max) <= max(qcircle(2,:)) && max(qcircle(2,:)) < 1.25*Max
%         lb = [lb, i];        
%         
%     elseif Min > min(qcircle(2,:))
%         break;
%     end
% end
% lb = min(lb);
% ub = max(ub);

end

