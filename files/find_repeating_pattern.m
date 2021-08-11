function [im, rep] = find_repeating_pattern(imgq,t)
Err = [];
err_min = inf;
for nang = linspace(4, 6, 100)
    imgq2 = imgq(:,[round(t/nang)+1:end 1:round(t/nang)],:);
    err = immse(imgq(:,t/2-t/(2*nang):t/2+t/(2*nang),:), imgq2(:,t/2-t/(2*nang):t/2+t/(2*nang),:));
    if err < err_min
        err_min = err;
        imgt = imgq;
    end
    Err = [Err;nang err];
end

[~,id] = min(Err(:,2));
rep = Err(id,1);
im = imgt(:,t/2-t/(2*rep):t/2+t/(2*rep),:);
rep = round(rep);
% rep = round(t/size(im,2));


end


