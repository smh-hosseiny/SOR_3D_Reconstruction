function cost = fittingfunction(theta,phi,lx,ly,rx,ry,K)

N = [sin(theta) * cos(phi);
    sin(theta) * sin(phi);
    cos(theta)];
cost = 0;
for i = 1:2:length(lx)
    ps = [lx(i); ly(i)];
    Ps = K\[ps;1];
    Qs = Ps-2*Ps'*N*N;
    qs = K*Qs./Qs(3,:);
    loss = intersection_loss(rx,ry,qs(1:2));
    cost = cost + loss;
end
end

