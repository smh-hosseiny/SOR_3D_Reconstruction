function symmetry_angle = find_symmetry_axis_reflection(mask)
    % FIND_SYMMETRY_AXIS_REFLECTION Detects the axis of symmetry using a reflection-based method.
    
    max_similarity = -Inf;  
    symmetry_angle = 0;     
    angle_step = 3;         
    
    [rows, cols] = size(mask);
    center = [cols/2, rows/2];
    
    % ----- Iterate Over Candidate Angles -----
    for angle = -90:angle_step:90
        rotated_mask = imrotate(mask, angle, 'nearest', "crop");
        flipped_mask = fliplr(rotated_mask);
        
        intersection = sum(rotated_mask & flipped_mask, 'all');  
        union = sum(rotated_mask| flipped_mask, 'all');        
        similarity = intersection / union;              
        
        if similarity > max_similarity
            max_similarity = similarity;
            symmetry_angle = angle;
        end
    end

  
   symmetry_angle = -symmetry_angle;
   
end