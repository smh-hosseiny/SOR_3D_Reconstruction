function [surface_patterns, profile] = fit_profile(Image,n, ang, Pbase, K,...
    p1, lb, ub, dh,f,bot_point,R)
   
    row = size(Image,1);
    col = size(Image,2);
    na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
    Rna = axang2rotm([n' ang*pi/180]);
    na = Rna*na;
    a = n;
    b = cross(a,na);
    % resolution of the reconstructed surface texture
    h = 384;
    w = 384;
    rh = zeros(1, h);
    he = zeros(1, h);

    th = linspace(0, 360, 2*w);
    counter = 1;
    % find angle range that captures surface patterns.
    % center = Pbase + lb*dh*na;
    % th0 = 0:60:360;
    % radius = find_radius(K, p1, center, a, b,f);
    % Points = center + radius*(a*cosd(th0)+b*sind(th0));
    % qcircle = K*Points;
    % qcircle = qcircle./repmat(qcircle(3,:),3,1);
    % [t, ~] = min(vecnorm([qcircle(1,:); qcircle(2,:)] - bot_point'));
    % if t < 180
    %     front_angle = 1:w;
    % else
    %     front_angle = w+1:2*w;
    % end
    
    surface_patterns = uint8(zeros(h,w,3));
    
    
    % generate circles
    for i = linspace(lb,ub,h)
        center = Pbase + i*dh*na;
        radius = find_radius(K, p1, center, a, b,f);
        he(counter) = i*dh;
        rh(counter) = radius;
        Points = center + radius*(a*cosd(th)+b*sind(th));
        % P = [P, Points];
        qcircle = K*Points;
        qcircle = qcircle./repmat(qcircle(3,:),3,1);

        [t, ~] = min(vecnorm([qcircle(1,:); qcircle(2,:)] - bot_point'));
        if t < 180
            front_angle = 1:w;
        else
            front_angle = w+1:2*w;
        end

        rotated_p = R' * qcircle(1:2,:);
        q = rotated_p(:, front_angle);
        hold on;
        if rem(counter,25) == 0
            plot(rotated_p(1,:), rotated_p(2,:),'g', 'linewidth',0.5);
            drawnow
        end
    
       
        y_ind = get_idx(q, 2, 1:w, row);
        x_ind = get_idx(q, 1, 1:w, col);
        lin = sub2ind(size(Image), repmat(y_ind, [3 1]), repmat(x_ind,...
            [3 1]), repmat([1;2;3], [1,w]));
        surface_patterns(counter, 1:w, :) = Image(lin)';

 
        counter = counter+1;
    end
    
    profile = [he; rh];
    % 3D points
    % P = reshape(P, [], 2*w, h);
    % P = permute(P, [3,2,1]);
    % X = P(:,:,1);
    % Y = P(:,:,2);
    % Z = P(:,:,3);
    %% Upsample
    % upsamplingFactor = 16;
    % % Upsample the coordinates
    % upsampledPointsX = interp1(1:size(points, 2), points(1, :), linspace(1, size(points, 2), size(points, 2) * upsamplingFactor), 'linear');
    % upsampledPointsY = interp1(1:size(points, 2), points(2, :), linspace(1, size(points, 2), size(points, 2) * upsamplingFactor), 'linear');
    % upsampledPointsZ = interp1(1:size(points, 2), points(3, :), linspace(1, size(points, 2), size(points, 2) * upsamplingFactor), 'linear');
    % 
    % % Combine the upsampled coordinates
    % upsampledPoints = [upsampledPointsX; upsampledPointsY; upsampledPointsZ];
    % upsampledPoints = reshape(upsampledPoints, [], 8*w, 4*l);
    % upsampledPoints = permute(upsampledPoints, [3,2,1]);
    % 
    % X = upsampledPoints(:,:,1);
    % Y = upsampledPoints(:,:,2);
    % Z = upsampledPoints(:,:,3);


end


