function loss = computeVisualLoss(ang, n, R, Pbase, K, p1, nrow, dh, top_point,bot_point,f, reference, masked)
    [lb, ub] = get_range(n, ang, Pbase, K, p1, nrow, dh,top_point,bot_point,f);
    patterns = surface_projection(masked, reference,R, n, Pbase, K, p1, lb, ub, dh,...
        bot_point, ang, f);
    
    lambda = 0.1;
    
    % try
    %     patterns = register_img(reference, patterns);
    % catch
    % 
    % end
            
    patterns(isnan(patterns)) = 0;
    l1 = 1 - ssim(patterns, reference);
    l2 = immse(patterns, reference);

    % Combine the similarity metrics
    loss = lambda * l2 + (1-lambda) * l1;
end
