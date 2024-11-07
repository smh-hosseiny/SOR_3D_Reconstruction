function [best_angle, best_loss] = find_angle(nrow, n, reference, masked, Pbase, K, p1, dh, ...
    top_point, bot_point, f, R, x, y, region_mask,symmetry_angle)
    
    % Preprocess images
    reference_img = double(rgb2gray(reference));
    masked = double(masked);
    %%
   
    angles = -10:10:20;
    loss = [];
    
    for ang = angles
        l = computeVisualLoss(ang, n, R, Pbase, K, p1, nrow, dh, top_point, ...
            bot_point, f, reference_img, masked,x,y, region_mask,symmetry_angle);
        loss = [loss, l];
    end
    
    [~, idx] = min(loss);
    initial_best_angle = angles(idx);

%% stage 2
% Define the loss function as an anonymous function
    lossFunction = @(ang) computeVisualLoss(ang, n, R, Pbase, K, p1, nrow, dh, ...
            top_point, bot_point, f, reference_img, masked,x,y, region_mask,symmetry_angle);
 % Set up the timer
    startTime = tic; % Start the timer

    % Define the output function to enforce the time limit
    function stop = outfun(~, ~, ~)
        stop = false;
        elapsedTime = toc(startTime);
        if elapsedTime > 2  % Time limit in seconds
            stop = true;
        end
    end

    % Set optimization options with the output function
    options = optimset('TolX', 1e-1, 'Display', 'off', 'OutputFcn', @outfun);

    % Adjust the search interval around zero if needed
    searchInterval = [initial_best_angle-5, initial_best_angle+5];  % Adjust as necessary

    % Use fminbnd to find the angle that minimizes the loss function
    [best_angle, best_loss] = fminbnd(lossFunction, searchInterval(1), searchInterval(2), options);

end
