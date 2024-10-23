function best_f = optimizeFocal(nrow, n, reference, masked, Pbase, K, p1, dh, top_point, bot_point, R, best_angle)
    % Preprocess images
    reference = double(rgb2gray(reference)) / 255;
    masked = double(rgb2gray(masked)) / 255;

    %% Initial coarse search over a range of focal lengths
    focals = [500, 1000];
    loss = zeros(size(focals));
    
    for idx = 1:length(focals)
        f = focals(idx);
        l = computeVisualLoss(best_angle,  n, R, Pbase, K, p1, nrow, dh, top_point,bot_point,f, reference, masked);
        loss(idx) = l;
    end
    
    [l1, idx_min] = min(loss);
    initial_best_focal = focals(idx_min);

    %% Stage 2: Refinement using fminbnd
    % Define the loss function as an anonymous function of f
    lossFunction = @(f) computeVisualLoss(best_angle,  n, R, Pbase, K, p1, nrow, dh, ...
                    top_point,bot_point,f, reference, masked);
    % Set up the timer
    startTime = tic; % Start the timer

    % Define the output function to enforce the time limit
    function stop = outfun(~, ~, ~)
        stop = false;
        elapsedTime = toc(startTime);
        if elapsedTime > 3  % Time limit in seconds
            stop = true;
        end
    end

    % Set optimization options with the output function
    options = optimset('TolX', 1e1, 'Display', 'off', 'OutputFcn', @outfun);

    % Adjust the search interval around the initial best focal length
    searchInterval = [initial_best_focal - 250, initial_best_focal + 250];
    % Ensure the search interval is valid (focal length cannot be negative)
    searchInterval(1) = max(searchInterval(1), 1); % Focal length must be positive

    % Use fminbnd to find the focal length that minimizes the loss function
    [best_f, minLoss] = fminbnd(lossFunction, searchInterval(1), searchInterval(2), options);
end