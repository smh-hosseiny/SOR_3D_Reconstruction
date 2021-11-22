function [idx, slope, top_point, m0] = get_top(x,y)
m = 4;
x_init = mean(x(1:m));
y_init = mean(y(1:m));
x_end = mean(x(end-m+1:end));
y_end = mean(y(end-m+1:end));
mean_x = (x_init+x_end)/2;
mean_y = (y_init+y_end)/2;

slope = (x_end-x_init) / (y_end-y_init);
slope = -1/slope;

yy = linspace(max(y),min(y), length(y));
xx = slope*(yy-mean_y) + mean_x;
% plot(xx,yy,'linewidth',1);  
p = InterX([x;y],[xx;yy]);
[~,idx] = min(vecnorm([x;y] - repmat([p(1); p(2)], [1,length(y)])));
% range = [p, [mean_x; mean_y]];
% initial_m = atan((p(2)-mean_y)/(p(1)-mean_x));
top_point = p(:,end);
m0 = atan(abs((p(2,end)-mean_y)/(p(1,end)-mean_x)));

end
