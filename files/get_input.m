
function [finalX, finalY] = get_input(Image,mesg)

workspace;  
samplingRateIncrease = 20;
% Image = imread(fullFileName);
figure;imshow(Image, []);
hold on;
axis on;
title('Image', 'FontSize', 10);
message = sprintf(mesg);
uiwait(msgbox(message));
[xCoordinates, yCoordinates] = ginput();
plot(xCoordinates, yCoordinates, 'rx', 'linewidth', 2);

numberOfKnots = length(xCoordinates);
% Close gaps that you get when you draw too fast.
% Use splines to interpolate a smoother curve,
% that goes exactly through the same data points.

newXSamplePoints = linspace(1, numberOfKnots, numberOfKnots * samplingRateIncrease);
% smoothedY = spline(xCoordinates, yCoordinates, newXSamplePoints);
yy = [0, xCoordinates', 0; 1, yCoordinates', 1];
pp = spline(1:numberOfKnots, yy); % Get interpolant
smoothedY = ppval(pp, newXSamplePoints); % Get smoothed y values in the "gaps".
SmoothedXCoordinates = smoothedY(1, :);
SmoothedYCoordinates = smoothedY(2, :);
% hold on; 
intSmoothedXCoordinates = int32(SmoothedXCoordinates);
intSmoothedYCoordinates = int32(SmoothedYCoordinates);
diffX = [1, diff(intSmoothedXCoordinates)];
diffY = [1, diff(intSmoothedYCoordinates)];
% Find out where both have zero difference from the prior point.
bothZero = (diffX==0) & (diffY == 0);
finalX = SmoothedXCoordinates(~bothZero);
finalY = SmoothedYCoordinates(~bothZero);
% plot(finalX, finalY, '-y');
end

