sizeZ = 1024;
Rawt = abs(Raw(1:sizeZ,:,:));
% Rawt = Raw(1:sizeZ,:,1:200);
clc;
test = pca(reshape(permute(abs(Rawt),[3 1 2]),[size(Rawt,3) size(Rawt,1)*size(Rawt,2)]));
% test = pca(reshape(permute(unwrap(angle(Raw_02(1:1024,:,:)),[],3),[3 1 2]),[150 1024*500]));
test_image = reshape(test(:,:,:),[size(Rawt,1) size(Rawt,2) size(Rawt,3)-1]);
test_image = var(test_image(:,:,2:end),0,3);
figure(1)
test_image = test_image - min(test_image(:));
test_image = test_image./max(test_image(:));
imagesc((test_image));
colorbar
axis equal tight
%%
I = test_image;
clc;
[L,Centers] = imsegkmeans(single(test_image),3);
B = labeloverlay(I,L);
imshow(B)
title('Labeled Image')
figure(2)
Lf = L;
Lf(Lf~=2) = 0;
imagesc(Lf)
axis tight equal