function err = Cost(i, Pbase, dh, na, n, K, p1, nrow,top_point,side,f)
center = Pbase + i*dh*na;
normal = na;
j = 0:360;
a = n;
b = cross(a,normal);
radius = find_radius(K, p1, center, a, b, f);
Points = center + radius*(a*cosd(j)+b*sind(j));
qcircle = K*Points;
qcircle = qcircle./repmat(qcircle(3,:),3,1);
err = evaluate_fitness(p1(4,:),p1(3,:),qcircle(1,:), qcircle(2,:),nrow, top_point,side);
if isempty(err)
    err = 1e5;
end
    
end