function refinedMask = refine_mask(mask)

    % preporocess the mask
    CC = bwconncomp(mask, 8);
    numPixels = cellfun(@numel, CC.PixelIdxList);
    
    % Create a cleaned mask with only the largest region
    [~, idx] = max(numPixels);
    refinedMask = false(size(mask));
    refinedMask(CC.PixelIdxList{idx}) = true;
    
    se = strel('disk', min(ceil(size(mask)./256)), 0);
    refinedMask = imopen(refinedMask, se);
    
    
end