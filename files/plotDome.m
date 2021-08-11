function [x,y,z,imgtt] = plotDome(lb, ub, prh, dh, Img)
%     nt = rep;
%     rimgt = repmat(Img(:,:,1),1,2*nt);
%     gimgt = repmat(Img(:,:,2),1,2*nt);
%     bimgt = repmat(Img(:,:,3),1,2*nt);
%     imgtt = [];
%     imgtt(:,:,1) = uint8(rimgt);
%     imgtt(:,:,2) = uint8(gimgt);
%     imgtt(:,:,3) = uint8(bimgt);

    fliped = flip(Img, 2);
    imgtt = cat(2,Img, fliped);
    imgtt = uint8(imgtt);
%     imgtt = imflatfield(imgtt, 30);
    h = lb*dh:dh/10:ub*dh;
    rh = get_rval(prh,h);
    [x,y,z] = cylinder(rh,size(imgtt,2)-1);
    z = repmat(h',1,size(imgtt,2));
    figure;
    surf(10*x,10*y,10*z,imgtt,'FaceColor','texturemap','Edgecolor','none');
    axis equal
    camproj('perspective');
    title('3D model');
    
end