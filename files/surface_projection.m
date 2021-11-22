function [RGB] = surface_projection(Image,n,Pbase,K,p1,lb,ub,dh,nrow,ncol,ang)

na = cross(n,[0;0;1])/norm(cross(n,[0;0;1]));
Rna = axang2rotm([n' ang*pi/180]);
na = Rna*na;
N = 20;
rh = zeros(1, N);
h = zeros(1, N);
a = n;
b = cross(a,na);

counter = 1;
for i = linspace(lb,ub,N)
    center = Pbase + i*dh*na;
    qc = K*center;
    qc = qc./qc(3,:);
    [radius,~,~] = get_rval(p1,qc(2));
    radius = radius/1000;
    h(counter) = i*dh;
    rh(counter) = radius;
    counter = counter+1;
end

cs = spline(h,[0 rh 0]);
height = linspace(min(h),max(h),100);
radius = ppval(cs,height);
profile = [height; radius];
th = linspace(0,360,400);
h = linspace(lb*dh,ub*dh,100);
l = length(h);
t = length(th);

projection = {};
counter = 1;
P = [];
for hq = h
    rq = interp1(height,radius,hq,'linear','extrap');
%     rq = get_rval(profile,hq);
    Points = (Pbase + hq*na + rq*(a*cosd(th)+b*sind(th)));
    P = [P Points];
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

m1 = reshape(P(1,:), [t, l]);
m2 = reshape(P(2,:), [t, l]);
m3 = reshape(P(3,:), [t, l]);


figure('visible','off');
surf(m1.',m2.',m3.', I,'FaceColor','texturemap','Edgecolor','none');
view(2);
axis equal;
set(gca, 'Visible', 'off');
set(gcf,'Color',[0 0 0]);
F = getframe;
rgb = frame2im(F);
rgb = flipud(rgb);
rgb = get_reshaped_img(rgb);
RGB = imresize(rgb, [nrow,ncol]);
% RGB = get_surface_patterns(rgb,nrow,ncol,x,y,K,n);
close;
end

function ix = get_idx(i, limit)
    ix = round(i);
    ix = min(ix, limit);
    ix = max(ix, 1);
end

function img = get_reshaped_img(rgb)
    x_idx = [];
    for i=1:size(rgb,2)
        if any(rgb(:,i,:),'all')
           x_idx = [x_idx, i]; 
        end
    end

    y_idx = [];
    for i=1:size(rgb,1)
        if any(rgb(i,:,:),'all')
           y_idx = [y_idx, i]; 
        end
    end

    minx = min(x_idx);
    maxx = max(x_idx);
    miny = min(y_idx);
    maxy = max(y_idx);
    img=imcrop(rgb,round([minx miny maxx-minx maxy-miny]));
end   