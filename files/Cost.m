function err = Cost(i, Pbase, dh, na, n, K, p1,extremum,f,side,bot_point,y_boundary, mask)
    
    center = Pbase + i*dh*na;
    normal = na;
    j = 0:4:360;
    a = n;
    b = cross(a,normal);
    radius = find_radius(K, p1,center, a, b, f, mask);
    Points = center + radius*(a*cosd(j)+b*sind(j));
    qcircle = K*Points;
    qcircle = qcircle./repmat(qcircle(3,:),3,1);

    [~,t] = min(vecnorm([qcircle(1,:); qcircle(2,:)] - bot_point'));
    w = floor(length(j)/2);
    if t <= w
        front_angle = 1:w;
    else
        front_angle = w+1:2*w;
    end

 
    % Projected x and y coordinates
    x_proj = qcircle(1, front_angle);
    y_proj = qcircle(2, front_angle);


    err = evaluate_fitness(p1(4,:),p1(3,:),x_proj, y_proj,mask, extremum,side);
    
    if isempty(err)
        err = 1e5;
    end
    
    if min(qcircle(2,:)) < min(y_boundary) || max(qcircle(2,:)) > max(y_boundary)
        err = err + 1e3;
    end

    
end