% Experimental - does not work
clc;
Raw_b = TRaw(:,:,1:2:end/2,:);
%%
Raw_b = fillmissing(Raw_b,'linear',2,'EndValues','nearest');
%%
for i=1:size(Raw_b,1)
    enface = squeeze(fftshift(fft2(squeeze(Raw_b(i,:,:,1)))));
    imagesc(log(abs(enface)))
    axis equal tight
    pause(0.01)
end
%%
stdRaw = nanstd(abs(Raw_t),0,4);
stdRaw = log(stdRaw+1);
stdRaw = stdRaw-min(stdRaw(:));
stdRaw = stdRaw./max(stdRaw(:));
h=implay(permute(stdRaw,[2 3 1]));
h.Visual.ColorMap.UserRange = true;
h.Visual.ColorMap.UserRangeMax = 1;
%%
Raw_t = Raw_b(:,376:500,:,:);
%%
clc
enface = squeeze(Raw_t(72,:,:,:));
enface_ref = enface;
for k=3
    inf.Zernike = zeros(size(enface,1),size(enface,2));
    for ii=1:1
        inf.Zernike(:,:,ii) = zernikePolN(ii+3,size(enface,1),size(enface,2));
    end
    Zernike = sum(inf.Zernike,3);
    Zernike = padarray(Zernike,[60 60],0,'both');
    Zernike = imresize(Zernike,[125 125]);
%     Zernike = 
    Zernike = Zernike.*k;
    for kk=1:size(enface,3)
        test = fftshift(fft2(squeeze(enface(:,:,kk))));
        [x,y] = detect_center(test);
        Zernike = circshift(circshift(Zernike,-(round(size(Zernike,1)/2)-y),1),-(round(size(Zernike,1)/2)-x),2);
        
        test = padarray(test,[30 30],'both');
        Zernike = padarray(Zernike,[30 30],'both');
        test = test.*exp(-1i.*Zernike);
        test = test(30+1:end-30,30+1:end-30);
        Zernike = Zernike(30+1:end-30,30+1:end-30);

        test = ifft2(ifftshift(test));
        enface_ref(:,:,kk) = test;
    end
end
stdRaw = std(abs(enface_ref),0,3);
stdRaw = log(stdRaw+1);
stdRaw = stdRaw-min(stdRaw(:));
stdRaw = stdRaw./max(stdRaw(:));
imagesc(stdRaw)
colormap gray
axis equal tight

%%
test = std(abs(enface_ref),0,3);
test = fftshift(fft2(test));
inf.Zernike = zeros(size(test,1),size(test,2));
for ii=1:1
    inf.Zernike(:,:,ii) = zernikePolN(ii+3,size(enface,1),size(enface,2));
end
Zernike = sum(inf.Zernike,3);
Zernike = padarray(Zernike,[30 30],0,'both');
Zernike = imresize(Zernike,[125 125]);
test = test.*exp(1i*-1*Zernike);
test = ifft2(ifftshift(test));
imagesc(log(abs(test)));
axis equal tight
colormap gray