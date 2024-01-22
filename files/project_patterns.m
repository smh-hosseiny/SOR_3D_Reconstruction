function [imgq] = project_patterns(lb,ub,dh,profile,Pbase,na,a,b,Image,K,front_angle,R)
row = size(Image,2);
col = size(Image,1);
h = linspace(lb*dh, ub*dh, 500);
l = length(h);

th = front_angle(1):0.2:front_angle(2);
t = length(th);
P = [];
for hq = h
    rq = interp1(profile(1,:), profile(2,:),hq,'pchip');
    P = [P (Pbase + hq*na + rq*(a*cosd(th)+b*sind(th)))];
end
q = K*P;
q = bsxfun(@rdivide, q, q(3,:));
q = R' * q(1:2,:);
imgq = uint8(zeros(l,t,3));
% X = reshape(q(1,:), t, [])';
% Y = reshape(q(2,:), t, [])';
% for c = 1:3
%     imgq(:, :, c) = uint8(interp2(double(Image(:, :, c)), Y, X, 'cubic'));
% end

for i = 1:l
    for j = 1:length(th)
        imgq(i,j,:) = Image(get_idx(2,i,j,col), get_idx(1,i,j,row),:);
    end
end


function ix = get_idx(idx,i,j,limit)
    ix = floor(q(idx,(i-1)*t+j));
    ix = min(ix, limit);
    ix = max(ix, 1);
end

end
