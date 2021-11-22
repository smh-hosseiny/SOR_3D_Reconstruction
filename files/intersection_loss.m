function loss = intersection_loss(x,y,p1,p2,slope)
slope = -1/slope;

yy = linspace(min(y), max(y), 2);
% yy = linspace(y_range(1), y_range(end), length(y));
xx = slope*(yy-p1(2)) + p1(1);
% plot(xx,yy);  
X = InterX([x;y],[xx;yy]);
% [~,idx] = min(vecnorm([x;y] - repmat([p(1); p(2)], [1,length(y)])));
% plot(X(1,end), X(2,end), 'r*');
if length(X)>1
    loss = norm(X(:,end) - p2);
%     sqrt((p(1)-get_rval(p2,p(2)))^2);
else
    loss = 1e4;
end

end