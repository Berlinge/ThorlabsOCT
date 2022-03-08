figure(1), clf(1)
imagesc(std(Raw(:,:,:),0,3))
axis equal tight

Rawt = Raw;
clc;
test = pca(reshape(permute(abs(Rawt),[3 1 2]),[size(Rawt,3) size(Rawt,1)*size(Rawt,2)]));
% test = pca(reshape(permute(unwrap(angle(Raw_02(1:1024,:,:)),[],3),[3 1 2]),[150 1024*500]));
test_image = reshape(test(:,:,:),[size(Rawt,1) size(Rawt,2) size(Rawt,3)-1]);
test_image = std(test_image(:,:,2:end),0,3);
test_image = log(medfilt2((test_image),[3 3])+1);
test_image = test_image-min(test_image(:));
test_image = test_image./max(test_image(:));
imagesc(test_image)
axis equal tight

%%
[centers,radii] = imfindcircles(test_image,[2 7],'ObjectPolarity','dark','Sensitivity',0.85);
viscircles(centers,radii);
% [cluster_idx cluster_center] = kmeans(test_image,3,'distance','sqEuclidean','Replicates',3);

%%
clc;
% I = dOCT(Raw,0);
% I = rgb2gray(I);
I = test_image;
BW = imbinarize(I,'adaptive');
[B,L] = bwboundaries(BW,'holes');
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end