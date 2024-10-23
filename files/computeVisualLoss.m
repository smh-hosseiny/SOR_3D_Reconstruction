function loss = computeVisualLoss(ang, n, R, Pbase, K, p1, nrow, dh, top_point,bot_point,f, reference, masked)
    [lb, ub] = get_range(n, ang, Pbase, K, p1, nrow, dh,top_point,bot_point,f);

    newK = K;
    newK(1,1) = newK(1,1) * f/500;
    newK(2,2) = newK(2,2) * f/500;

    [patterns, status] = surface_projection(masked, reference,R, n, Pbase, newK, p1, lb, ub, dh,...
        bot_point, ang, f);

    if status ~= 0
        loss = 1e4;
        return
    end

  
    
    try
        patterns = register_img(reference, patterns);
    catch

    end
          
    lambda = 0.1; 
    patterns(isnan(patterns)) = 0;
    l1 = 1 - ssim(patterns, reference);
    l2 = immse(patterns, reference);

    % Combine the similarity metrics
    loss = lambda * l2 + (1-lambda) * l1;
end
