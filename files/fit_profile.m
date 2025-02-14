function [surface_patterns, profile] = fit_profile(Image,n, ang, Pbase, K,...
    p1, lb, ub, dh,f,bot_point,R,x_boundary,y_boundary, mask2,symmetry_angle)
   
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
    rh = nan(1, h);
    he = nan(1, h);

    th = linspace(0, 360, 2*w);
    counter = 1;
    surface_patterns = uint8(255 * ones(h,w,3));
   
    % fron mask
    num_levels = 5;
    height_ratios = linspace(0.25, 0.75, num_levels);  % spread between 10% and 30% of height
    all_idx = zeros(1, num_levels);
    
    for level = 1:num_levels
        i = lb + height_ratios(level)*(ub-lb);
        center = Pbase + i*dh*na;
        th0 = [90, 270];
        radius = find_radius(K, p1, center, a, b, f, mask2, 5000);
        Points = center + radius*(a*cosd(th0)+b*sind(th0));
        qcircle = K*Points;
        qcircle = qcircle./repmat(qcircle(3,:), 3, 1);
        [~, all_idx(level)] = min(vecnorm([qcircle(1,:); qcircle(2,:)] - bot_point'));
    end
    
    idx = mode(all_idx);  % most common index
    front_angle = (1:w) + (idx-1)*w;
 

    %% generate circles
    for i = linspace(lb,ub,h)
        center = Pbase + i*dh*na;
        radius = find_radius(K, p1, center, a, b,f, mask2, 6000);
        he(counter) = i*dh;
        rh(counter) = radius;


        Points = center + radius*(a*cosd(th)+b*sind(th));
       

        % if rem(counter, 10) == 0           
        %     plot3(Points(1, :), Points(2, :), Points(3, :), 'k', 'LineWidth', 1);
        % 
        % end

        qcircle = K*Points;
        qcircle = bsxfun(@rdivide, qcircle, qcircle(3,:));

        % Projected x and y coordinates
        x_proj = qcircle(1, front_angle);
        y_proj = qcircle(2, front_angle);

        if min(y_proj) < min(y_boundary)
            continue;
        end

        theta_indices = 1:length(x_proj);
        % Rotate the points
        rotated_p = R' * qcircle(1:2, front_angle(theta_indices));
        q = rotated_p;


        % Plot every 10th circle for visualization
        if rem(counter, 10) == 0
            plot(rotated_p(1, :), rotated_p(2, :), 'g', 'linewidth', 1);
            drawnow

            back_theta = setdiff(1:2*w, front_angle);
            rotated_p2 = R' * qcircle(1:2, back_theta);
            plot(rotated_p2(1, :), rotated_p2(2, :), 'g--', 'linewidth', 0.5);
        end


        % Get indices for image extraction
        y_ind = get_idx(q, 2, 1:length(theta_indices), row);
        x_ind = get_idx(q, 1, 1:length(theta_indices), col);
        y_rep = repmat(y_ind, [3, 1]); % Size: [3, N]
        x_rep = repmat(x_ind, [3, 1]); % Size: [3, N]
        
        color_indices = repmat([1; 2; 3], [1, length(theta_indices)]); 
        lin = sub2ind(size(Image), y_rep, x_rep, color_indices);

        RGB_original = reshape(Image(lin), [3, length(theta_indices)]).';  
        surface_patterns(counter, theta_indices, :) = RGB_original;

        counter = counter + 1;



    end
    
    
    filtered_radius = imgaussfilt(rh, 10);
    profile = [he; filtered_radius];

 

end


function RGB_interpolated = interpolate_RGB(RGB_original, x, new_length)
    % interpolate_RGB Interpolates RGB values from original to new_length
 
   [~, num_channels] = size(RGB_original);
    if num_channels ~= 3
        error('RGB_original must be an N x 3 matrix, where N is the number of points.');
    end
   
    RGB_original = double(RGB_original);
    
    % Define original and new sampling points
    x_original = x/new_length;
    x_new = linspace(0, 1, new_length);           
    RGB_interpolated = zeros(new_length, 3);
    
    % Interpolate each color channel separately
    for channel = 1:3
        channel_data = RGB_original(:, channel);        
        interpolated_channel = interp1(x_original, channel_data, x_new, 'spline');     
        interpolated_channel(isnan(interpolated_channel)) = channel_data(end);
        RGB_interpolated(:, channel) = interpolated_channel;
    end
    
    RGB_interpolated = max(min(RGB_interpolated, 255), 0);
    RGB_interpolated = uint8(round(RGB_interpolated));


end