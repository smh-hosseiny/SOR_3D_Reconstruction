function [best_angle, best_loss] = find_angle(n, masked, Pbase, K, p1, dh, ...
    top_point, bot_point, f, R, y, region_mask,symmetry_angle)
    
    % Preprocess images
    angles = -10:10:20;
    loss = [];
    
    for ang = angles
        l = computeVisualLoss(ang, n, R, Pbase, K, p1, dh, top_point, ...
            bot_point, f, masked,y, region_mask,symmetry_angle);
        loss = [loss, l];
    end
    
    [~, idx] = min(loss);
    initial_best_angle = angles(idx);

    %% stage 2

    lossFunction = @(ang) computeVisualLoss(ang, n, R, Pbase, K, p1, dh, ...
            top_point, bot_point, f, masked,y, region_mask,symmetry_angle);
    
    startTime = tic; % Start the timer

    % Define the output function to enforce the time limit
    function stop = outfun(~, ~, ~)
        stop = false;
        elapsedTime = toc(startTime);
        if elapsedTime > 2  
            stop = true;
        end
    end

    options = optimset('TolX', 1e-1, 'Display', 'off', 'OutputFcn', @outfun);
    searchInterval = [initial_best_angle-5, initial_best_angle+5];  % Adjust as necessary
    [best_angle, best_loss] = fminbnd(lossFunction, searchInterval(1), searchInterval(2), options);

end
