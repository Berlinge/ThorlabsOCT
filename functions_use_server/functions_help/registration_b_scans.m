function [output] = registration_b_scans(Raw)
clc;
FIXED = squeeze(Raw(:,:,1));
output = Raw;
for t = 2:size(Raw,3)
    try
    MOVING = squeeze(Raw(:,:,t));
    fixedRefObj = imref2d(size(FIXED));
    movingRefObj = imref2d(size(MOVING));
    % Phase correlation
    tform = imregcorr(MOVING,movingRefObj,FIXED,fixedRefObj,'transformtype','translation','Window',true);
    MOVINGREG.Transformation = tform;
    MOVINGREG.RegisteredImage = imwarp(MOVING, movingRefObj, tform, 'OutputView', fixedRefObj, 'SmoothEdges', true);
    % Store spatial referencing object
    MOVINGREG.SpatialRefObj = fixedRefObj;
    output(:,:,t) = MOVINGREG.RegisteredImage;
    catch
        
    end
end
end