function [best_focal, best_K, new_dh] = optimizeFocal(masked, ...
    K, dh, top_point, R, best_angle,lx,ly,rx,ry,region_mask, f0, best_init_loss,symmetry_angle)
    
    % Initial coarse search over a range of focal lengths

    focals = [500, 1200, 1800, f0];
    loss = zeros(size(focals));
    loss(end) = best_init_loss;
    
    for idx = 1:length(focals)-1
        f = focals(idx);
        newK = K;
        newK(1,1) = newK(1,1) * f/f0;
        newK(2,2) = newK(2,2) * f/f0;
        new_dh = dh * (f0/f);

        [~,y,n,Pbase,p1,tp,bot_point] = get_border(lx,ly,rx,ry,top_point,newK,R);
        l = computeVisualLoss(best_angle,  n, R, Pbase, newK, p1, new_dh, ...
            tp,bot_point,f, masked,y,region_mask,symmetry_angle);
        loss(idx) = l;
    end
    
    [~, idx_min] = min(loss);
    initial_best_focal = focals(idx_min);

    
    %% Stage 2: Refinement using fminbnd
    lossFunction = @(f) get_focal_loss(best_angle, R, K, dh, ...
                    top_point,f, masked, lx,ly,rx,ry,region_mask,f0,symmetry_angle);

    startTime = tic; % Start the timer

    % Define the output function to enforce the time limit
    function stop = outfun(~, ~, ~)
        stop = false;
        elapsedTime = toc(startTime);
        if elapsedTime > 2  
            stop = true;
        end
    end

    options = optimset('TolX', 1e1, 'Display', 'off', 'OutputFcn', @outfun);
    searchInterval = [initial_best_focal - 100, initial_best_focal + 100];
    searchInterval(1) = max(searchInterval(1), 1); % Focal length must be positive


    %% Use fminbnd to find the focal length that minimizes the loss function
    [best_focal, ~] = fminbnd(lossFunction, searchInterval(1), searchInterval(2), options);

    best_K = K;
    best_K(1,1) = best_K(1,1) * best_focal/f0;
    best_K(2,2) = best_K(2,2) * best_focal/f0;

    new_dh = dh * (f0/best_focal);

end


function loss = get_focal_loss(best_angle, R, K, dh, ...
                    top_point,f, masked, lx,ly,rx,ry,region_mask,f0,symmetry_angle)

    newK = K;
    newK(1,1) = newK(1,1) * f/f0;
    newK(2,2) = newK(2,2) * f/f0;
    new_dh = dh * (f0/f);

    [~,y,n,Pbase,p1,tp,bot_point] = get_border(lx,ly,rx,ry,top_point,newK,R);

    loss = computeVisualLoss(best_angle,  n, R, Pbase, newK, p1, new_dh, ...
                    tp,bot_point,f, masked,y,region_mask,symmetry_angle);
end