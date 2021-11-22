function cost = normalCost(x,p1,p2,kmin,kmax,K)
n = [cos(x(1))*sin(x(2));
    sin(x(1));
    cos(x(1))*cos(x(2))];
cost = 0;
for i = kmin:-10:kmax
    ps = [get_rval(p1,i);i];
    Ps = K\[ps;1];
    Qs = Ps-2*Ps'*n*n;
    qs = K*Qs./Qs(3,:);
    cost = cost + (qs(1)-get_rval(p2,qs(2)))^2;
end
end

