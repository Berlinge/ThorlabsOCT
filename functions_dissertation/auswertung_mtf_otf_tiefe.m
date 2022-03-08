load('E:\OneDrive\Dissertation\Daten\2019-11-19 Zunge 28 Phasenkorrigiert mit Alg.mat')
%%
clc;
figure(1), clf(1);
R = Raw(1:1024,:,1);
R_std = std(abs(Raw(1:1024,:,:)),0,3);

subplot(2,4,1) % 1. B-scan
image = 20.*log10(abs(R));
imagesc(image)
axis equal tight 
title('std')
colorbar

subplot(2,4,2) % MTF
image = log(abs(fftshift(fft(image,500,2),2)));
image = (image-min(image(:)))./max(image(:)-min(image(:)));
imagesc(image);
axis equal tight
colormap gray
title('MTF')
colorbar

subplot(2,4,6) % OTF
image = log(abs(fftshift(fft(R(:,:),500,2),2)));
image = (image-min(image(:)))./max(image(:)-min(image(:)));
imagesc(circshift(image,-100,2));
axis equal tight
title('OTF')
colorbar

subplot(2,4,3)
image = abs(R_std);
imagesc(log(image))
axis equal tight 
title('std')
colorbar

subplot(2,4,4)
image = log(abs(fftshift(fft(image,500,2),2)));
image = (image-min(image(:)))./max(image(:)-min(image(:)));
MTF = imagesc(image);
axis equal tight
colormap gray
title('MTF')
colorbar

Rawt = Raw(1:1024,:,:);
% Rawt = Raw(1:sizeZ,:,1:200);
clc;
test = pca(reshape(permute(abs(Rawt),[3 1 2]),[size(Rawt,3) size(Rawt,1)*size(Rawt,2)]));
% test = pca(reshape(permute(unwrap(angle(Raw_02(1:1024,:,:)),[],3),[3 1 2]),[150 1024*500]));
image = reshape(test(:,:,:),[size(Rawt,1) size(Rawt,2) size(Rawt,3)-1]);
image = std(image(:,:,2:end),0,3);
image = log(medfilt2((image),[3 3])+1);

subplot(2,4,7)
imagesc(image)
axis equal tight
colorbar

subplot(2,4,8)
image = log(abs(fftshift(fft(image,500,2),2)));
image = (image-min(image(:)))./max(image(:)-min(image(:)));
MTF = imagesc(image);
axis equal tight
colormap gray
title('MTF')
colorbar