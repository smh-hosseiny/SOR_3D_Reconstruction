function loss = computeVisualLoss(ang, n, R, Pbase, K, p1, nrow, dh, top_point, ...
    bot_point,f, reference, masked,x,y, region_mask,symmetry_angle)
    

    [lb, ub] = get_range(n, ang, Pbase, K, p1, nrow, dh,top_point,bot_point,f,x,y,region_mask);

    [patterns, status] = surface_projection(masked, reference, R, n, Pbase, K, p1, lb, ub, dh,...
        bot_point, ang, f,x,y,region_mask,symmetry_angle);

    if status ~= 0
        loss = 1e4;
        return
    end
    
    % try
    %     patterns = register_img(reference, patterns);
    % catch
    % 
    % end
          
    lambda = 0.001; 
    patterns(isnan(patterns)) = 0;

    l1 = 1 - ssim(patterns, masked);
    l2 = immse(patterns, masked);

    % Combine the similarity metrics
    loss = lambda * l2 + (1-lambda) * l1;
end
