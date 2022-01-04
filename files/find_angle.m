function best_angle = find_angle(Image,nrow,s1,s2,n,reference,Pbase,K,p1,dh,top_point,f)
angle = [-20,-10,0,10,20,30];
score = [];
idx1 = round(1*s1/10:9*s1/10);
idx2 = round(2*s2/10:8*s2/10);
for ang = angle
    [lb, ub] = get_range(n, ang, Pbase, K, p1, nrow, dh,top_point,f);
    [RGB] = surface_projection(Image,n,Pbase,K,p1,lb,ub,dh,s1,s2,ang,f); 
    s = ssim(RGB(idx1,idx2,:), reference(idx1,idx2,:));
    score = [score, s];
end

[hs, idx] = max(score);
ba = angle(idx);
score2 = [];
phase_2_angle = [ba-4, ba-2, ba+2, ba+4];
for ang = phase_2_angle
    [lb, ub] = get_range(n, ang, Pbase, K, p1, nrow, dh,top_point,f);
    [RGB]  = surface_projection(Image,n,Pbase,K,p1,lb,ub,dh,s1,s2,ang,f); 
    s = ssim(RGB(idx1,idx2,:), reference(idx1,idx2,:));
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

