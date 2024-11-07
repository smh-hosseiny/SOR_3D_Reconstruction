function [v, u] = get_mask_boundary(mask)
    CC = bwconncomp(mask);  % Find connected components
    
    v = [];
    u = [];
    
    for k = 1:CC.NumObjects
        % Create a mask for each connected component
        componentMask = false(size(mask));
        componentMask(CC.PixelIdxList{k}) = true;
    
        % Get boundaries of the component
        boundaries = bwboundaries(componentMask, 'noholes', 'TraceStyle', 'pixelcenter');
        
        % Process each boundary (although most components will have just one)
        for j = 1:length(boundaries)
            boundary = boundaries{j};  % Boundary is already sequential
    
            % Extract the boundary points (rows and columns)
            v = [v, boundary(:, 1)'];  % Rows -> Z
            u = [u, boundary(:, 2)'];  % Columns -> X
        end
    end

    v = v';
    u = u';

end