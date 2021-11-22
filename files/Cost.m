function err = Cost(i, Pbase, dh, na, n, K, p1, nrow,top_point,side)
center = Pbase + i*dh*na;
normal = na;
j = 0:360;
a = n;
b = cross(a,normal);
qc = K*center;
qc = qc./qc(3,:);
[radius,~,~] = get_rval(p1,qc(2));
radius = radius/1000;
Points = center + radius*(a*cosd(j)+b*sind(j));
qcircle = K*Points;
qcircle = qcircle./repmat(qcircle(3,:),3,1);
err = evaluate_fitness(p1(4,:),p1(3,:),qcircle(1,:), qcircle(2,:),nrow, top_point,side);
if isempty(err)
    err = 1e5;
end
    
end