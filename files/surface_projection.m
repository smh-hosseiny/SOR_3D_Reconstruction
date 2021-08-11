function I = surface_projection(Image, r1,r2, n, Pbase, K, p1, lb, ub, dh, nrow, ncol,ang)

na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
Rna = axang2rotm([n' ang*pi/180]);
na = Rna*na;
rh = zeros(1, 15);
h = zeros(1, 15);

counter = 1;
for i = linspace(lb,ub,15)
    circle.center = Pbase + i*dh*na;
    circle.normal = na;
    j = r1:r2;
    a = n;
    b = cross(a,na);
    for r = .01:.001:1
        circle.radius = r;
        circle.Points = circle.center + circle.radius*(a*cosd(j)+b*sind(j));
        qcircle = K*[circle.Points];
        qcircle = qcircle./repmat(qcircle(3,:),3,1);
        xm = get_rval(p1,qcircle(2,:));
        if sum(qcircle(1,:)<xm) > 0
            break;
        end
    end
    h(counter) = i*dh;
    rh(counter) = r;
    counter = counter+1;
end

cs = spline(h,[0 rh 0]);
height = linspace(min(h),max(h),100);
radius = ppval(cs,height);
profile = [height; radius];





h = linspace(lb*dh,ub*dh,nrow);
th = linspace(r1,r2, ncol);
l = length(h);
t = length(th);

projection = {};
counter = 1;
for hq = h
    rq = get_rval(profile,hq);
    Points = (Pbase + hq*na + rq*(a*cosd(th)+b*sind(th)));
    qcircle = K*Points;
    qcircle = bsxfun(@rdivide, qcircle, qcircle(3,:));
    projection{counter} = [get_idx(qcircle(1,:), size(Image,2)); get_idx(qcircle(2,:), size(Image,1))];
    counter = counter + 1;
end

I = uint8(zeros(l,t,3));
for i = 1:l
    idx = projection{i};
    for j=1:t
       I(i,j,:) = Image(idx(2,j), idx(1,j), :); 
    end
end

end

function ix = get_idx(i, limit)
    ix = round(i);
    ix = min(ix, limit);
    ix = max(ix, 1);
end