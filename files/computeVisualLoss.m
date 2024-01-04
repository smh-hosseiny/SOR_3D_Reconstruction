function loss = computeVisualLoss(ang, n, Pbase, K, p1, nrow, dh, top_point,bot_point,f, reference)
    [lb, ub] = get_range(n, ang, Pbase, K, p1, nrow, dh,top_point,bot_point,f);
    [RGB,I] = surface_projection(reference, n, Pbase, K, p1, lb, ub, dh, size(reference, 1), size(reference, 2), ang, f);
    
    lambda = 0.1;
    
    try
        patterns = register_img(I, RGB);
    catch
        patterns = RGB;
    end
    gray_reference = rgb2gray(I);
    gray_patterns = rgb2gray(patterns);

    maxVal = max(gray_reference(:), [], 'all');
    l1 = 1 - ssim(gray_patterns, gray_reference);
    l2 = immse(gray_patterns ./ maxVal, gray_reference ./ maxVal);

    % Combine the similarity metrics as needed
    loss = lambda * l2 + (1-lambda) * l1;
end
