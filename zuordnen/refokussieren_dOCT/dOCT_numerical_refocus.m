% Experimental - does not work
fftimage = fftshift(fft(Raw(:,:,10),size(Raw,2),2),2);
imagesc(log(abs(fftimage)))
%%
z_verschiebung = -25;
clc
for k=-150
    start_points = [k 0 -0.5 0.5]; % sp z y1 y2
    inf.Zernike = zeros(size(fftimage,1),size(fftimage,2));
    for i=1:1
        inf.Zernike(:,:,i) = zernikePolN(i+3,size(fftimage,1),size(fftimage,2));
    end
    inf.Zernike = sum(inf.Zernike,3);
    Zernike = inf.Zernike(512,:);
    Zernike = repmat(Zernike,[size(fftimage,1) 1]);
    Zernike = Zernike.*(abs(linspace(start_points(3),start_points(4),size(Zernike,1))'+start_points(2))*start_points(1));
    [t1,t2] = max(movmean(mean(abs(Raw(:,:,1)),2),100)); %
    Zernike = circshift(Zernike,-(500-round(t2)),1);
    imagesc(Zernike)
%     Zernike = circshift(Zernike,10,2);
    Zernike_back = Zernike;
    RawR = Raw;
    for i=1:150
        if i>1
%             Zernike = circshift(Zernike_back,-round(z_verschiebung(i)),1);
        end
        test = RawR(:,:,i);
        test = fftshift(fft(test,size(test,2),2),2);
        test = test.*exp(-1i.*Zernike);
        test = ifft(ifftshift(test,2),size(test,2),2);
        RawR(:,:,i) = test;
%         figure(1)
%         imagesc(Zernike)
%         figure(2)
%         imagesc(octa(test))
%         pause(0.01)
    end
    subplot(1,2,1)
imagesc(Zernike)
subplot(1,2,2)
imagesc(log(dOCT(RawR,0)+1)+0.4)
axis equal tight
pause(0.01)
end

% % Registration
% RawR = abs(RawR);
% FIXED = squeeze(RawR(:,:,1));
% output = RawR;
% for t = 2:size(RawR,3)
%     MOVING = squeeze(RawR(:,:,t));
%     MOVINGREG.Transformation = tform_backup(t);
%     MOVINGREG.RegisteredImage = imwarp(MOVING, movingRefObj, tform_backup(t), 'OutputView', fixedRefObj, 'SmoothEdges', true);
%     % Store spatial referencing object
%     MOVINGREG.SpatialRefObj = fixedRefObj;
%     [x,z] = transformPointsForward(tform,0,0);
%     %     MOVINGREG2.Transformation = tform;
%     %     MOVINGREG2.RegisteredImage = imwarp(squeeze(p(:,:,t)), movingRefObj, tform, 'OutputView', fixedRefObj, 'SmoothEdges', true);
%     %     % Store spatial referencing object
%     %     MOVINGREG2.SpatialRefObj = fixedRefObj;
%     output(:,:,t) = MOVINGREG.RegisteredImage;
%     %     output2(:,:,t) = MOVINGREG2.RegisteredImage;
% end
%
% test = pca(reshape(permute(abs(output),[3 1 2]),[size(output,3) size(output,1)*size(output,2)]));
% test = pca(reshape(permute(unwrap(angle(Raw_02(1:1024,:,:)),[],3),[3 1 2]),[150 1024*500]));
% image = reshape(test(:,:,:),[size(output,1) size(output,2) size(output,3)-1]);
% image = std(image(:,:,2:end),0,3);
% image = log(medfilt2((image),[3 3])+1);
% imagesc(abs(image))
% axis equal tight