function [imgq, t] = project_patterns(lb,ub,dh,profile,Pbase,na,a,b,Image,K)
row = size(Image,2);
col = size(Image,1);
h = lb*dh:dh/10:ub*dh;
l = length(h);
th = 0:0.1:180;
t = length(th);
P = [];
for hq = h
    rq = get_rval(profile,hq);
    P = [P (Pbase + hq*na + rq*(a*cosd(th)+b*sind(th)))];
end
q = K*P;
q = bsxfun(@rdivide, q, q(3,:));
imgq = uint8(zeros(l,t,3));
for i = 1:l
    for j = 1:length(th)
%         imgq(i,j,:) = Image(floor(q(2,(i-1)*t+j)), floor(q(1,(i-1)*t+j)), :);
        imgq(i,j,:) = Image(get_idx(2,i,j,col), get_idx(1,i,j,row), :);
    end
end

shift = floor(size(imgq,2)/7);
imgq = imgq(:,shift:end-shift,:);

function ix = get_idx(idx,i,j,limit)
    ix = floor(q(idx,(i-1)*t+j));
    ix = min(ix, limit);
    ix = max(ix, 1);
end

end


