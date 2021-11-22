function [r,x,y] = get_rval(prh, h)
    val = interp1(prh(1,:).',prh(2:4,:).',h,'linear','extrap');
    r = val(:,1);
    x = val(:,3);
    y = val(:,2);
    
%     height = prh(1,:); radius = prh(2,:);
%     d = pdist2(h.', height.','minkowski',2);
%     [~, ix] = mink(d, 1, 2);
%     r_val = radius(ix);
end

% function r_val = get_rval(prh, h)
%     options = optimoptions('fmincon');
%     options.Display = 'off';
%     xi = mean(prh(1,:));
%     r_val = [];
%     for i = 1:length(h)
%         r = fmincon(@(x) costfun(x,h(i),prh),xi,[],[],[],[],...
%         [],[],[],options);
%         r_val = [r_val; r];
%     end
% end
% 
% function cost = costfun(x,h,prh)
% cost = min(vecnorm(prh-repmat([x;h],1,length(prh))));
% end