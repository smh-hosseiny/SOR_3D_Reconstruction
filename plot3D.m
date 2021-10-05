function [x,y,z,imgtt] = plot3D(lb, ub, prh, dh, Img)
    fliped = flip(Img, 2);
    imgtt = cat(2,Img, fliped);
    imgtt = uint8(imgtt);
    h = linspace(lb*dh, ub*dh, 640);
    rh = get_rval(prh,h);
    [x,y,~] = cylinder(rh,size(imgtt,2)-1);
    z = repmat(h',1,size(imgtt,2));
    figure;
    surf(10*x,10*y,10*z,imgtt,'FaceColor','texturemap','Edgecolor','none');
    axis equal
    camproj('perspective');
    title('3D model');
        
end


