t = 50;
mag_part = mag(:,:,1:t);
mag_pca = pca(reshape(permute(mag_part,[3 1 2]),[size(mag_part,3) size(mag_part,1)*size(mag_part,2)]));
mag_pca = reshape(mag_pca(:,:,:),[size(mag_part,1) size(mag_part,2) size(mag_part,3)-1]);
mag_pca = std(mag_pca(:,:,2:end),0,3);
mag_pca = medfilt2((mag_pca),[3 3]);
mag_pca = log(mag_pca+1);
mag_pca = (mag_pca-min(mag_pca(:)))./max(max(mag_pca-min(mag_pca(:))));
%% 
imagesc(mag_pca)
colormap gray
axis equal tight
title(t)
if 