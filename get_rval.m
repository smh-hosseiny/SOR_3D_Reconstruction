function r_val = get_rval(prh, h)
    height = prh(1,:); radius = prh(2,:);
    d = pdist2(h.', height.','minkowski',2);
    [~, ix] = mink(d, 1, 2);
    r_val = radius(ix);
end