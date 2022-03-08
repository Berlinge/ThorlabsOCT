function [MOVINGOutput] = RefAffine(FIXED,MOVING)
finiteIdx = isfinite(FIXED(:));
FIXED(isnan(FIXED)) = 0;% Replace Inf values with 1
FIXED(FIXED==Inf) = 1;
FIXED(FIXED==-Inf) = 0;% Replace -Inf values with 0
FIXEDmin = min(FIXED(:));% Normalize input data to range in [0,1].
FIXEDmax = max(FIXED(:));
if isequal(FIXEDmax,FIXEDmin)
    FIXED = 0*FIXED;
else
    FIXED(finiteIdx) = (FIXED(finiteIdx) - FIXEDmin) ./ (FIXEDmax - FIXEDmin);
end
% Normalize MOVING image
finiteIdx = isfinite(MOVING(:));% Get linear indices to finite valued data
MOVING(isnan(MOVING)) = 0;% Replace NaN values with 0
MOVING(MOVING==Inf) = 1;% Replace Inf values with 1
MOVING(MOVING==-Inf) = 0;% Replace -Inf values with 0
MOVINGmin = min(MOVING(:));% Normalize input data to range in [0,1].
MOVINGmax = max(MOVING(:));
if isequal(MOVINGmax,MOVINGmin)
    MOVING = 0*MOVING;
else
    MOVING(finiteIdx) = (MOVING(finiteIdx) - MOVINGmin) ./ (MOVINGmax - MOVINGmin);
end
% Default spatial referencing objects
fixedRefObj = imref2d(size(FIXED));
movingRefObj = imref2d(size(MOVING));
% Detect SURF features
fixedPoints = detectSURFFeatures(FIXED,'MetricThreshold',500.000000,'NumOctaves',4,'NumScaleLevels',6);
movingPoints = detectSURFFeatures(MOVING,'MetricThreshold',500.000000,'NumOctaves',4,'NumScaleLevels',6);
% Extract features
[fixedFeatures,fixedValidPoints] = extractFeatures(FIXED,fixedPoints,'Upright',false);
[movingFeatures,movingValidPoints] = extractFeatures(MOVING,movingPoints,'Upright',false);
% Match features
indexPairs = matchFeatures(fixedFeatures,movingFeatures,'MatchThreshold',50.000000,'MaxRatio',0.500000);
fixedMatchedPoints = fixedValidPoints(indexPairs(:,1));
movingMatchedPoints = movingValidPoints(indexPairs(:,2));
MOVINGREG.FixedMatchedFeatures = fixedMatchedPoints;
MOVINGREG.MovingMatchedFeatures = movingMatchedPoints;
% Apply transformation - Results may not be identical between runs because of the randomized nature of the algorithm
try
tform = estimateGeometricTransform(movingMatchedPoints,fixedMatchedPoints,'affine');
MOVINGREG.Transformation = tform;
MOVINGREG.RegisteredImage = imwarp(MOVING, movingRefObj, tform, 'OutputView', fixedRefObj, 'SmoothEdges', true);
% Store spatial referencing object
MOVINGREG.SpatialRefObj = fixedRefObj;
MOVINGOutput = MOVINGREG.RegisteredImage;
catch
    MOVINGOutput = MOVING;
end
end