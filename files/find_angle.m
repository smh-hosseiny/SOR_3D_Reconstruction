function best_angle = find_angle(nrow,n,reference,masked,Pbase,K,p1,dh,top_point,bot_point,f,R)


reference = double(rgb2gray(reference))/255;
masked = double(rgb2gray(masked))/255;

angles = -10:10:20;
loss = [];

for ang = angles
    l = computeVisualLoss(ang, n, R, Pbase, K, p1, nrow, dh, top_point, bot_point, f, reference, masked);
    loss = [loss, l];
end

[l1 idx] = min(loss);
ba = angles(idx);

%% stage 2

loss2 = [];
phase_2_angle = [ba-3, ba+3];
for ang = phase_2_angle
    l = computeVisualLoss(ang, n, R, Pbase, K, p1, nrow, dh, top_point, bot_point, f, reference, masked);
    loss2 = [loss2, l];
end

[l2, idx2] = min(loss2);
ba2 = phase_2_angle(idx2);

if l2 < l1
    best_angle = ba2;
else
    best_angle = ba;
end

