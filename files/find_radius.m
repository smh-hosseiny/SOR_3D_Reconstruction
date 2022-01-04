function radius = find_radius(K, p1, center, a, b, f)
x = p1(4,:);
y = p1(3,:);
qc = K*center;
qc = qc./qc(3,:);
[r0,~,~] = get_rval(p1,qc(2));
r0 = r0/f;
    
options = optimoptions('fminunc');
options.Display = 'off';
options.MaxFunEvals = 200;
radius = fminunc(@(r) cost(r,x,y,center,a,b,K),r0, options);

end


function c = cost(r,x,y,center,a,b,K)
    radius = r;
    j = 180;
    Points = center + radius*(a*cosd(j)+b*sind(j));
    qcircle = K*Points;
    qcircle = qcircle./repmat(qcircle(3,:),3,1);
    c = min(vecnorm([x;y]-[qcircle(1);qcircle(2)]));
end