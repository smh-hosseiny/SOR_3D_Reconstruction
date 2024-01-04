function [registeredImage] = register_img(image1,image2)
grayImage1 = rgb2gray(image1);
grayImage2 = rgb2gray(image2);

% Ensure both images have the same size
if ~isequal(size(grayImage1), size(grayImage2))
    grayImage2 = imresize(grayImage2, size(grayImage1));
end

% Create SIFT feature point object
points1 = detectSURFFeatures(grayImage1);
points2 = detectSURFFeatures(grayImage2);

% Extract SIFT features
[features1, validPoints1] = extractFeatures(grayImage1, points1);
[features2, validPoints2] = extractFeatures(grayImage2, points2);

% Match features
indexPairs = matchFeatures(features1, features2);

% Get matched points
matchedPoints1 = validPoints1(indexPairs(:, 1));
matchedPoints2 = validPoints2(indexPairs(:, 2));

% Estimate geometric transformation (RANSAC)
tform = estgeotform2d(matchedPoints2, matchedPoints1, 'rigid');

% Apply transformation to one image
registeredImage = imwarp(image2, tform, 'OutputView', imref2d(size(grayImage1)));

end