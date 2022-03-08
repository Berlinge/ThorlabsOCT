function [output] = registration_b_scans_floating(Raw)
clc;
output = Raw;
for t = 2:size(Raw,3)
    FIXED = squeeze(output(:,:,t-1));
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
end
end