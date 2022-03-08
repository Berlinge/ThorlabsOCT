%% 
Raw = Raw_back;
p = angle(Raw);
Raw = abs(Raw);
clc;
FIXED = squeeze(Raw(:,:,1));
output = Raw;
outputp = Raw;
for t = 2:size(Raw,3)
    MOVING = squeeze(Raw(:,:,t));
    fixedRefObj = imref2d(size(FIXED));
    movingRefObj = imref2d(size(MOVING));
    % Phase correlation
    tform = imregcorr(MOVING,movingRefObj,FIXED,fixedRefObj,'transformtype','translation','Window',true);
    
    MOVINGREG.Transformation = tform;
    tform_backup(t) = tform;
    MOVINGREG.RegisteredImage = imwarp(MOVING, movingRefObj, tform, 'OutputView', fixedRefObj, 'SmoothEdges', true);
    % Store spatial referencing object
    MOVINGREG.SpatialRefObj = fixedRefObj;
    
    [x,z] = transformPointsForward(tform,0,0);
    list(t,1:2) = [x z]; % x z Verschiebungsvektor ueber die Zeit
%     MOVINGREG2.Transformation = tform;
%     MOVINGREG2.RegisteredImage = imwarp(squeeze(p(:,:,t)), movingRefObj, tform, 'OutputView', fixedRefObj, 'SmoothEdges', true);
%     % Store spatial referencing object
%     MOVINGREG2.SpatialRefObj = fixedRefObj;
    
    output(:,:,t) = MOVINGREG.RegisteredImage;
%     output2(:,:,t) = MOVINGREG2.RegisteredImage;
end
%%
figure
for i=1:150
    plot(list(i,1),list(i,2),'ro')
    hold on
end
%%
z_verschiebung = list(:,2);
x_verschiebung  = list(:,1);
%% Verschiebung von x
for i=1:150
    Test(:,:,i) = circshift(angle(Raw_back(:,:,i)),round(x_verschiebung(i)),2);
    Test(:,:,i) = circshift(angle(Test(:,:,i)),round(z_verschiebung(i)),1);
end
implay(Test)
%%
Test2 = zeros(1024,800,150);
for i=1:150
    Test2(:,101+round(x_verschiebung(i)):600+round(x_verschiebung(i)),i) = angle(Raw_back(:,:,i));
    Test2(:,101+round(z_verschiebung(i)):600+round(z_verschiebung(i)),i) = angle(Raw_back(:,:,i));
end
%%
fft_p = fft(p,size(p,2),2);
for ii=1:150
    mc_p = fft_p
end