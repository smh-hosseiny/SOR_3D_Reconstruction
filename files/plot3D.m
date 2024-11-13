function [x,y,z,imgtt] = plot3D(lb, ub, prh, dh, Img)
    Img = imresize(Img,2);
    w = size(Img,2);
    Img = Img(:,round(0.02*w):round(0.98*w),:);
    fliped = flip(Img, 2);
    imgtt = cat(2,fliped, Img);
    imgtt = uint8(imgtt);

    h = linspace(lb*dh, ub*dh, size(imgtt,1));
    idx = ~isnan(prh(1,:));
    rh = interp1(prh(1,idx), prh(2,idx),h,'linear');
    [x,y,~] = cylinder(rh,size(imgtt,2)-1);
    z = repmat(h',1,size(imgtt,2));
    
    x = 100 * x;
    y = 100 * y;
    z = 100 * z;
end


