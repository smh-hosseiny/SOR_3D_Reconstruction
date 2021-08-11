function [finalX,finalY] = splineInterp(xCoordinates, yCoordinates) 
    samplingRateIncrease = 2;
    numberOfKnots = length(xCoordinates);
    newXSamplePoints = linspace(1, numberOfKnots, numberOfKnots * samplingRateIncrease);
    % smoothedY = spline(xCoordinates, yCoordinates, newXSamplePoints);
    yy = [0, xCoordinates, 0; 1, yCoordinates, 1];
    pp = spline(1:numberOfKnots, yy); % Get interpolant
    smoothedY = ppval(pp, newXSamplePoints); % Get smoothed y values in the "gaps".
    SmoothedXCoordinates = smoothedY(1, :);
    SmoothedYCoordinates = smoothedY(2, :);

    diffX = [1, diff(SmoothedXCoordinates)];
    diffY = [1, diff(SmoothedYCoordinates)];
    % Find out where both have zero difference from the prior point.
    bothZero = (diffX==0) & (diffY == 0);
    finalX = SmoothedXCoordinates(~bothZero);
    finalY = SmoothedYCoordinates(~bothZero);
    
end

