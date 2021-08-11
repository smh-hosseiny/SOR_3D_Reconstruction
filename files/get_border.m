function [x_border ,y_border ,n,Pbase,p1] = get_border(xCoordinates, yCoordinates, K)
[~,i] = min(yCoordinates);
[~, minx] = min(xCoordinates);

if ismember(minx, 1:i)
    lx = xCoordinates(1:i); ly = yCoordinates(1:i);
    rx = xCoordinates(i:end); ry = yCoordinates(i:end);
else
    rx = xCoordinates(1:i); ry = yCoordinates(1:i);
    lx = xCoordinates(i:end); ly = yCoordinates(i:end);
end
warning off
% order = 7;
% p1 = polyfit(ly,lx,order);
[height,radius] = splineInterp(ly, lx);
p1 = [height; radius];
% plot(polyval(p1,ly),ly,'r','linewidth',1)
[height2,radius2] = splineInterp(ry, rx);
p2 = [height2; radius2];
% p2 = polyfit(ry,rx,order);
% plot(polyval(p2,ry),ry,'r','linewidth',1)

if ismember(minx, 1:i)
%     x_border = [polyval(p1,ly), polyval(p2,ry)];
    x_border = [get_rval(p1,ly), get_rval(p2,ry)];
    y_border = [ly, ry];
else
    x_border = [flip(get_rval(p1,ly)), flip(get_rval(p2,ry))];
    y_border = [flip(ly), flip(ry)];
end

% find symmetric line
options = optimoptions('fmincon');
options.Display = 'off';
kmin = round(min(min(ly), min(ry)));
kmax = round(max(max(ly), max(ry)));
d = kmax - kmin;
k1 = kmin + 0.01*d;
k2 = kmin + 0.99*d;
x = fmincon(@(x) normalCost(x,p1,p2,k1,k2,K),[0 pi/2],[],[],[],[],[-pi/2 -pi],[pi/2 pi],[],options);
n = [cos(x(1))*sin(x(2));sin(x(1));cos(x(1))*cos(x(2))];
n = n/norm(n);
N = 50;
idx = linspace(k1,k2,N);
qsa = zeros(2,N);
k = 0;

for i = idx
    k = k + 1;
    ps = [get_rval(p1,i);i];
%     plot(ps(1),ps(2),'g.')
    Ps = K\[ps;1];
%     Qs = Ps-2*Ps'*n*n;
%     qs = K*Qs./Qs(3,:);
%     plot(qs(1),qs(2),'r.')
    Qs = Ps-Ps'*n*n;
    qs = K*Qs./Qs(3,:);
%     plot(qs(1),qs(2),'m.');
    qsa(:,k) = qs(1:2);
end
pa = polyfit(qsa(2,:),qsa(1,:),1);
ys = [k1 k2];
xs = polyval(pa,ys);
% plot(xs, ys, 'r', 'linewidth',2);
Pbase = K\[xs(2);ys(2);1];
% Pend = K\[xs(1);ys(1);1];


end

