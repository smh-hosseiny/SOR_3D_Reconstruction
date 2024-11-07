function symmetry_angle = find_symmetry_axis_reflection(mask)
    % FIND_SYMMETRY_AXIS_REFLECTION Detects the axis of symmetry using a reflection-based method.

    % Initialize variables
    % max_similarity = -Inf;
    % symmetry_angle = 0;
    % angle_step = 1;
    % 
    % % Define the center of the image for rotation
    % [rows, cols] = size(mask);
    % center = [cols/2, rows/2];
    % 
    % % Extract coordinates of all true pixels
    % [y, x] = find(mask);
    % 
    % % Shift coordinates to center
    % coords = [x - center(1), y - center(2)]';  % 2xN matrix
    % 
    % for angle = -89:angle_step:90
    %     reflected_mask = zeros(size(mask));
    %     % Define rotation matrix for reflection across the axis
    %     theta = deg2rad(angle);
    %     R = [cos(theta), sin(theta); sin(theta), -cos(theta)];
    %     % Reflect the coordinates
    %     reflected = R * coords;  % 2xN matrix
    % 
    %     % Shift back to original coordinate system
    %     reflected_x = reflected(1, :) + center(1);
    %     reflected_y = reflected(2, :) + center(2);
    % 
    %     reflected_x_rounded = round(reflected_x);
    %     reflected_y_rounded = round(reflected_y);
    % 
    %     reflected_x_clipped = min(max(reflected_x_rounded, 1), size(mask, 2));
    %     reflected_y_clipped = min(max(reflected_y_rounded, 1), size(mask, 1));
    % 
    %     % reflected_mask = interp2(X, Y, double(mask), reflected_x, reflected_y, 'nearest', 0);
    %     reflected_mask(sub2ind(size(mask), reflected_y_clipped, reflected_x_clipped)) = 1;
    %     reflected_mask = logical(reflected_mask);
    % 
    %     % Compute similarity metric (Intersection Over Union - IoU)
    %     intersection = sum(mask(:) & reflected_mask(:));
    %     union = sum(mask(:) | reflected_mask(:));
    %     similarity = intersection / union;
    % 
    %     % Update maximum similarity and symmetry angle
    %     if similarity > max_similarity
    %         max_similarity = similarity;
    %         symmetry_angle = angle;
    %     end
    % 
    % 
    % end
    %%
    max_similarity = -Inf;  % Initialize maximum similarity
    symmetry_angle = 0;     % Initialize symmetry angle
    angle_step = 1;         % Degree step size for candidate angles
    
    % Define the center of the image (optional, used for visualization)
    [rows, cols] = size(mask);
    center = [cols/2, rows/2];
    
    % ----- Iterate Over Candidate Angles -----
    for angle = -90:angle_step:90
        % ----- Step 1: Rotate the Mask -----
        rotated_mask = imrotate(mask, angle, 'nearest', "crop");
        % ----- Step 2: Flip the Rotated Mask Left to Right -----
        flipped_mask = fliplr(rotated_mask);
        
        % ----- Step 3: Compute Similarity Metric (IoU) -----
        intersection = sum(rotated_mask & flipped_mask, 'all');  % Logical AND
        union = sum(rotated_mask| flipped_mask, 'all');         % Logical OR
        similarity = intersection / union;              % IoU Calculation
        
        % ----- Step 4: Update Maximum Similarity and Symmetry Angle -----
        if similarity > max_similarity
            max_similarity = similarity;
            symmetry_angle = angle;
        end
    end

    % symmetry_angle
    % new_mask = imrotate(mask, symmetry_angle, 'nearest', "crop");
   %%
   symmetry_angle = -symmetry_angle;
   % + 90;  %angle frim x-axis
end