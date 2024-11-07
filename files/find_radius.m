function radius = find_radius(K, p1, center, a, b, f, mask, iteration)

if nargin < 8
    iteration = 120;
end

x = p1(4,:);
y = p1(3,:);
qc = K*center;
qc = qc./qc(3,:);
[r0,~,~] = get_rval(p1,qc(2));
r0 = r0/f;
    
options = optimoptions('fminunc');
options.Display = 'off';
options.MaxFunEvals = iteration;
% radius = fminunc(@(r) cost(r,x,y,center,a,b,K),r0, options);

radius=fminsearchbnd(@(r) cost(r,x,y,center,a,b,K,mask), r0, 1e-5, 0.75);

end


function c = cost(r,x,y,center,a,b,K,mask)
    j = 1:10:360;
    Points = center + r*(a*cosd(j)+b*sind(j));
    qcircle = K*Points;
    qcircle = qcircle./repmat(qcircle(3,:),3,1);
   
    [~, idx1] = min(qcircle(1,:));
    [~, idx2] = max(qcircle(1,:));

    x_circle = qcircle(1, [idx1, idx2]);
    y_circle = qcircle(2, [idx1, idx2]);


    % [~, idx2] = min(qcircle(2,:));
    % id = min(idx1,idx2):max(idx1,idx2);
    % points = qcircle(1:2,id);
    % nei = get_neighbors(x, y, points);
    % min_distance = vecnorm(points(2,:) - nei(2,:));

    % Compute minimum distance to the silhouette boundary
    distances = zeros(size(x_circle));
    for i = 1:length(x_circle)
        distances(i) = min(hypot(x_circle(i) - x, y_circle(i) - y));
    end
    min_distance = min(distances);
    

    % % Shift coordinates to ensure all are positive
    min_x = min(x);
    min_y = min(y);
    
    % Determine shift amounts only if necessary
    if min_x <= 0
        shift_x = abs(min_x) + 1; % Shift to make min(x) = 1
    else
        shift_x = 0;
    end
    
    if min_y <= 0
        shift_y = abs(min_y) + 1; % Shift to make min(y) = 1
    else
        shift_y = 0;
    end
    
    % Apply shifts
    qcircle(1,:) = qcircle(1,:) + shift_x;
    qcircle(2,:) = qcircle(2,:) + shift_y;
    
    idx = sub2ind(size(mask), min(max(1,round(qcircle(2,:))), size(mask,1)), ...
        min(max(1,round(qcircle(1,:))),  size(mask,2)) );
    penalty_outside = sum(~mask(idx)); % Large penalty for each point outside


    % Cost combines penalties and promotes tangency
    c = 1e8*penalty_outside + 1e1*min_distance;


   
    % loss = intersection_loss(x,y,points);
    % c = loss + 5*min(vecnorm([x;y]-[min_x;qcircle(2,idx1)])) + penalty_outside;


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