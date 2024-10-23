function radius = find_radius(K, p1, center, a, b, f)
x = p1(4,:);
y = p1(3,:);
qc = K*center;
qc = qc./qc(3,:);
[r0,~,~] = get_rval(p1,qc(2));
r0 = r0/f;
    
options = optimoptions('fminunc');
options.Display = 'off';
options.MaxFunEvals = 150;
radius = fminunc(@(r) cost(r,x,y,center,a,b,K),r0, options);

% radius=fminsearchbnd(@(r) cost(r,x,y,center,a,b,K), r0, 0, 0.1);

end


function c = cost(r,x,y,center,a,b,K)
    j = 1:2:360;
    Points = center + r*(a*cosd(j)+b*sind(j));
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


    % vectorized
    % j = 1:360;
    % radius = (a*cosd(j)+b*sind(j)) .* permute(r, [3, 2, 1]);
    % cc = repmat(center, [1 1 length(j)]);
    % Points = permute(radius, ([1 3 2])) + cc;
    % qcircle = K * reshape(Points, 3, []);
    % qcircle = qcircle(1:2,:) ./ qcircle(3,:);
    % % Reshape the result back to 3-by-M-by-N
    % qcircle = reshape(qcircle, 2, [], length(j));
    % [min_x, idx1] = min(qcircle(1,:,:), [], 3);
    % [~, idx2] = min(qcircle(2,:,:), [], 3);
    % id = min([idx1,idx2]):max([idx1,idx2]);
    % points = qcircle(1:2,:,id);
    % nei = get_neighbors(x, y, points);
    % bounds_loss = vecnorm(points(2,:,:) - repmat(nei(2,:), [1 1 size(points, 3)]), 2, 3);
    % 
    % distances = pdist2([min_x;qcircle(2,idx1)]', [x;y]');
    % tangency_loss = min(distances, [], 2);
    % c = sum(bounds_loss' + 5*tangency_loss); 

end