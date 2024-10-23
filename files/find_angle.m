function best_angle = find_angle(nrow, n, reference, masked, Pbase, K, p1, dh, top_point, bot_point, f, R)
    % Preprocess images
    reference_img = double(rgb2gray(reference)) / 255;
    masked = double(rgb2gray(masked)) / 255;

   
    angles = -10:10:20;
    loss = [];
    
    for ang = angles
        l = computeVisualLoss(ang, n, R, Pbase, K, p1, nrow, dh, top_point, bot_point, f, reference_img, masked);
        loss = [loss, l];
    end
    
    [l1 idx] = min(loss);
    initial_best_angle = angles(idx);

%% stage 2
% Define the loss function as an anonymous function
    lossFunction = @(ang) computeVisualLoss(ang, n, R, Pbase, K, p1, nrow, dh, ...
                                            top_point, bot_point, f, reference_img, masked);
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
    options = optimset('TolX', 1e-1, 'Display', 'off', 'OutputFcn', @outfun);

    % Adjust the search interval around zero if needed
    searchInterval = [initial_best_angle-5, initial_best_angle+5];  % Adjust as necessary

    % Use fminbnd to find the angle that minimizes the loss function
    [best_angle, minLoss] = fminbnd(lossFunction, searchInterval(1), searchInterval(2), options);

end

% loss2 = [];
% phase_2_angle = [ba-3, ba+3];
% for ang = phase_2_angle
%     l = computeVisualLoss(ang, n, R, Pbase, K, p1, nrow, dh, top_point, bot_point, f, reference, masked);
%     loss2 = [loss2, l];
% end
% 
% [l2, idx2] = min(loss2);
% ba2 = phase_2_angle(idx2);
% 
% if l2 < l1
%     best_angle = ba2;
% else
%     best_angle = ba;
% end

