function [registeredImage] = register_img(grayImage1,grayImage2)


% Create SIFT feature point object
points1 = detectSURFFeatures(grayImage1, 'MetricThreshold', 50);
points2 = detectSURFFeatures(grayImage2, 'MetricThreshold', 50);

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
registeredImage = imwarp(grayImage2, tform, 'OutputView', imref2d(size(grayImage1)));

end