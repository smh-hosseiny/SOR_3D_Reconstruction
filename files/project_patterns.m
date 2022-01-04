function [imgq, t] = project_patterns(lb,ub,dh,profile,Pbase,na,a,b,Image,K)
row = size(Image,2);
col = size(Image,1);
h = linspace(lb*dh, ub*dh, 300);
l = length(h);

th = 0:0.1:180;
t = length(th);
P = [];
for hq = h
    rq = interp1(profile(1,:), profile(2,:),hq,'linear','extrap');
    P = [P (Pbase + hq*na + rq*(a*cosd(th)+b*sind(th)))];
end
q = K*P;
q = bsxfun(@rdivide, q, q(3,:));
imgq = uint8(zeros(l,t,3));
for i = 1:l
    for j = 1:length(th)
        imgq(i,j,:) = Image(get_idx(2,i,j,col), get_idx(1,i,j,row), :);
    end
end

shift = floor(size(imgq,2)/11);
imgq = imgq(:,shift:end-shift,:);


function ix = get_idx(idx,i,j,limit)
    ix = floor(q(idx,(i-1)*t+j));
    ix = min(ix, limit);
    ix = max(ix, 1);
end

end
