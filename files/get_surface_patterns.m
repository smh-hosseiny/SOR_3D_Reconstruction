function [temp,s1,s2] = get_surface_patterns(Image,nrow,ncol,x,y)
mask = poly2mask(x, y, nrow, ncol);
I = bsxfun(@times, Image, cast(mask, 'like', Image));

minx = min(x);
maxx = max(x);
miny = min(y);
maxy = max(y);
sub=imcrop(I,round([minx miny maxx-minx maxy-miny]));
s1 = size(sub,1); s2=size(sub,2);
sub = flipud(sub);


temp = sub;
for i=1:size(sub,1)
    row = sub(i,:,:);
    black_idx = row(:,:,1) == 0 & row(:,:,2) == 0 & row(:,:,3) == 0;
    idx = find(black_idx == 0);
    if ~isempty(idx)
        rgb = row(1,min(idx):max(idx),:);
        stretched = imresize(rgb, [1, size(row,2)]);
    else
        stretched = row;
    end
    temp(i,:,:) = stretched;
end
end

