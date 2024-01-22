function ix = get_idx(q,idx,j,limit)
    ix = round(q(idx,j));
    ix = min(ix, limit);
    ix = max(ix, 1);
end
