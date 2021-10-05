function err = Cost(i, Pbase, dh, na, n, K, p1, x,y, nrow,side)
center = Pbase + i*dh*na;
normal = na;
j = 0:180;
a = n;
b = cross(a,normal);
for r = .01:.001:1.5
    radius = r;
    Points = center + radius*(a*cosd(j)+b*sind(j));
    qcircle = K*Points;
    qcircle = qcircle./repmat(qcircle(3,:),3,1);
    xm = get_rval(p1,qcircle(2,:));
    if sum(qcircle(1,:)<xm) > 0
        break;
    end
end
err = evaluate_fitness(x,y,qcircle(1,:), qcircle(2,:),nrow, side);
if isempty(err)
    err = 1e5;
end
    
end