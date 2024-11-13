% Define the scaling factor
scaleFactor = 0.5;  % 4 times the original resolution

% originalImage = Image;
% Get original dimensions
[originalHeight, originalWidth, numChannels] = size(originalImage);

% Calculate new dimensions
newWidth = originalWidth * scaleFactor;
newHeight = originalHeight * scaleFactor;


% Upscale using different interpolation methods

% 1. Nearest-Neighbor Interpolation
upscaledNearest = imresize(originalImage, scaleFactor, 'nearest');

% 2. Bilinear Interpolation
upscaledBilinear = imresize(originalImage, scaleFactor, 'bilinear');

% 3. Bicubic Interpolation
upscaledBicubic = imresize(originalImage, scaleFactor, 'bicubic');

% 4. Lanczos Interpolation
upscaledLanczos = imresize(originalImage, scaleFactor, 'lanczos3');

% Display upscaled images
figure('Name', 'Upscaled Images');
subplot(2,2,1);
imshow(upscaledNearest);
title('Nearest-Neighbor');

subplot(2,2,2);
imshow(upscaledBilinear);
title('Bilinear');

subplot(2,2,3);
imshow(upscaledBicubic);
title('Bicubic');

subplot(2,2,4);
imshow(upscaledLanczos);
title('Lanczos');



% imwrite(upscaledNearest, 'upscaled_nearest.png');
% imwrite(upscaledBilinear, 'upscaled_bilinear.png');
% imwrite(upscaledBicubic, 'upscaled_bicubic.png');
% imwrite(upscaledLanczos, 'upscaled_lanczos.png');

