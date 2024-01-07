function radius = find_radius(K, p1, center, a, b, f)
x = p1(4,:);
y = p1(3,:);
qc = K*center;
qc = qc./qc(3,:);
[r0,~,~] = get_rval(p1,qc(2));
r0 = r0/f;
    
options = optimoptions('fminunc');
options.Display = 'off';
options.MaxFunEvals = 100;
radius = fminunc(@(r) cost(r,x,y,center,a,b,K),r0, options);

end


function c = cost(r,x,y,center,a,b,K)
    radius = r;
    j = 0:360;
    Points = center + radius*(a*cosd(j)+b*sind(j));
    qcircle = K*Points;
    qcircle = qcircle./repmat(qcircle(3,:),3,1);
    [min_x, idx1] = min(qcircle(1,:));
    [~, idx2] = min(qcircle(2,:));
    id = min(idx1,idx2):max(idx1,idx2);
    points = qcircle(1:2,id);
    nei = get_neighbors(x, y, points);
    loss = vecnorm(points(2,:) - nei(2,:));
    % loss = intersection_loss(x,y,points);
    c = loss + 5*min(vecnorm([x;y]-[min_x;qcircle(2,idx1)]));
end