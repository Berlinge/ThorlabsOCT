data = abs(Raw(1:1024,:,1:150));
% m = mean(data(:),1);
data = data-mean(data,1);
[X,score,latent,tsquared,explained,mu] = pca(reshape(permute(data,[3 1 2]),[size(data,3) size(data,1)*size(data,2)]));
X_rs = reshape(X(:,:,:),[size(data,1) size(data,2) size(data,3)-1]);
image = std(X_rs(:,:,1:end),0,3);
%mag_pca = mean(mag_pca(:,:,2:end),3);
%mag_pca = medfilt2((mag_pca),[3 3]);
image = log(image+1);
image = (image-min(image(:)))./max(max(image-min(image(:))));
figure(1); clf(1)
subplot(1,2,1)
imagesc(image)

subplot(1,2,2)
image = std(data,0,3).^2;
image = log(image+1);
image = (image-min(image(:)))./max(max(image-min(image(:))));
imagesc(image)