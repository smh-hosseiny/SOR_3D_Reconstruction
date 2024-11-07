function [best_focal, best_K] = optimizeFocal(nrow, reference, masked, ...
    K, dh, top_point, R, best_angle,lx,ly,rx,ry,region_mask, f0, best_init_loss,symmetry_angle)
    
% Preprocess images,
    % reference = double(rgb2gray(reference)) / 255;
    % masked = double(rgb2gray(masked)) / 255;
    masked = double(masked);
    %% Initial coarse search over a range of focal lengths
    focals = [300, 1200, 1800, f0];
    loss = zeros(size(focals));
    loss(end) = best_init_loss;
    
    for idx = 1:length(focals)-1
        f = focals(idx);
        newK = K;
        newK(1,1) = newK(1,1) * f/f0;
        newK(2,2) = newK(2,2) * f/f0;

        % new_dh = dh * (500/f);
        [x,y,n,Pbase,p1,tp,bot_point] = get_border(lx,ly,rx,ry,top_point,newK,R);
        l = computeVisualLoss(best_angle,  n, R, Pbase, newK, p1, nrow, dh, ...
            tp,bot_point,f, reference, masked,x,y,region_mask,symmetry_angle);
        loss(idx) = l;
    end
    
    [~, idx_min] = min(loss);
    initial_best_focal = focals(idx_min);

    %% Stage 2: Refinement using fminbnd
    lossFunction = @(f) get_focal_loss(best_angle, R, K, nrow, dh, ...
                    top_point,f, reference, masked, lx,ly,rx,ry,region_mask,f0,symmetry_angle);

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
    options = optimset('TolX', 1e1, 'Display', 'off', 'OutputFcn', @outfun);

    % Adjust the search interval around the initial best focal length
    searchInterval = [initial_best_focal - 100, initial_best_focal + 100];
    % Ensure the search interval is valid (focal length cannot be negative)
    searchInterval(1) = max(searchInterval(1), 1); % Focal length must be positive

    %% Use fminbnd to find the focal length that minimizes the loss function
    [best_focal, ~] = fminbnd(lossFunction, searchInterval(1), searchInterval(2), options);

    best_K = K;
    best_K(1,1) = best_K(1,1) * best_focal/f0;
    best_K(2,2) = best_K(2,2) * best_focal/f0;

end


function loss = get_focal_loss(best_angle, R, K, nrow, dh, ...
                    top_point,f, reference, masked, lx,ly,rx,ry,region_mask,f0,symmetry_angle)

    newK = K;
    newK(1,1) = newK(1,1) * f/f0;
    newK(2,2) = newK(2,2) * f/f0;

    [x,y,n,Pbase,p1,tp,bot_point] = get_border(lx,ly,rx,ry,top_point,newK,R);

    loss = computeVisualLoss(best_angle,  n, R, Pbase, newK, p1, nrow, dh, ...
                    tp,bot_point,f, reference, masked,x,y,region_mask,symmetry_angle);
end