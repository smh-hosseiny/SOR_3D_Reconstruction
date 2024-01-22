function [x,y,z,imgtt] = plot3D(lb, ub, prh, dh, Img)
    Img = imresize(Img,2);
    w = size(Img,2);
    Img = Img(:,round(0.1*w):round(0.9*w),:);
    fliped = flip(Img, 2);
    imgtt = cat(2,Img, fliped);
    imgtt = uint8(imgtt);
    h = linspace(lb*dh, ub*dh, size(imgtt,1));
    rh = interp1(prh(1,:), prh(2,:),h,'linear');
    [x,y,~] = cylinder(rh,size(imgtt,2)-1);
    z = repmat(h',1,size(imgtt,2));
    % figure;
    % surf(10*x,10*y,10*z,imgtt,'FaceColor','texturemap','Edgecolor','none');
    % if n(1) < 0
    %     set(gca,'xdir','reverse');
    %     set(gca, 'Zdir', 'reverse');
    % end
    % 
    % axis equal
    % camproj('perspective');
    % title('3D model');
    % 
end


