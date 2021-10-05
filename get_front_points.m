function [rng] = get_front_points(px, py)
[~,idx1] = min(px);
[~,idx2] = max(px);
[~,ymax] = max(py);

u_rng = (min(idx1,idx2): max(idx1,idx2));
rng3 = (1:min(idx1,idx2));
rng2 = (max(idx1,idx2):length(px));
l_rng = cat(1, [rng2,rng3]);

if ismember(ymax,l_rng)
    rng = l_rng;
else
    rng = u_rng;
end
end

