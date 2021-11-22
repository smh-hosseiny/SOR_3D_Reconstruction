function [xs,ys,top_point,slope] = get_symm_line(lx,ly,x_border,y_border,n,K)
N = 100;
qsa = zeros(2,N);
k = 0;
n = [cos(n(1))*sin(n(2));sin(n(1));cos(n(1))*cos(n(2))];
n = n/norm(n);

for i = round(linspace(1,210,N))
    k = k + 1;
    ps = [lx(i);ly(i)];
    Ps = K\[ps;1];
    Qs = Ps-Ps'*n*n;
    qs = K*Qs./Qs(3,:);
    qsa(:,k) = qs(1:2);
end

% plot(qsa(1,:), qsa(2,:), 'ko', 'linewidth',2);

pa = polyfit(qsa(2,:),qsa(1,:),1);
yy = [min(y_border) max(y_border)];
xx = polyval(pa,yy);
X = InterX([x_border;y_border],[xx;yy]);
y1= X(2,end);

X2 = InterX([[x_border(1), x_border(end)];[y_border(1), y_border(end)]],[xx;yy]);
y2 = X2(2,end);
ys = [y2 y1];
xs = polyval(pa,ys);
top_point = [xs(end), ys(end)];

slope = (xs(end)-xs(1)) / (ys(end)-ys(1));
% slope = -1/slope;
end

