function best_angle = find_angle(Image,x,y,nrow,n,refrence,s1,s2,Pbase, K, p1, dh)
angle = [-10,0,10,20,30];
score = [];
for ang = angle
    [lb, ub] = get_range(n, ang, x,y, Pbase, K, p1, nrow, dh);
    RGB = surface_projection(Image, n, Pbase, K, p1, lb, ub, dh, s1, s2,ang); 
    s = ssim(RGB, refrence);
    score = [score, s];
end

[hs, idx] = max(score);
ba = angle(idx);
score2 = [];
phase_2_angle = [ba-3, ba+3];
for ang = phase_2_angle
    [lb, ub] = get_range(n, ang, x,y, Pbase, K, p1, nrow, dh);
    RGB = surface_projection(Image, n, Pbase, K, p1, lb, ub, dh, s1, s2,ang); 
    s = ssim(RGB, refrence);
    score2 = [score2, s];
end

[hs2, idx2] = max(score2);
ba2 = phase_2_angle(idx2);

if hs2 > hs
    best_angle = ba2;
else
    best_angle = ba;
end

end

