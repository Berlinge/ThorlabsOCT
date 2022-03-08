
Rawt = Raw(1:1024,:,:);
% Rawt = Raw(1:sizeZ,:,1:200);
clc;
test = pca(reshape(permute(abs(Rawt),[3 1 2]),[size(Rawt,3) size(Rawt,1)*size(Rawt,2)]));
% test = pca(reshape(permute(unwrap(angle(Raw_02(1:1024,:,:)),[],3),[3 1 2]),[150 1024*500]));
image = reshape(test(:,:,:),[size(Rawt,1) size(Rawt,2) size(Rawt,3)-1]);
image = std(image(:,:,2:end),0,3);
image = log(medfilt2((image),[3 3])+1);
% f_pca = figure;
% figure(f_pca)
% imagesc(test_image); axis equal tight
%
Raw_b = abs(Raw(1:1024,:,:));
% Raw_b = unwrap(Raw_b,[],3);
Raw_b = fft(Raw_b,size(Raw_b,3),3);
Raw_b = Raw_b(1:1024,:,:);
testb = sum(abs(Raw_b(:,:,1:1)),3);
testg = sum(abs(Raw_b(:,:,1:9)),3);
testr = sum(abs(Raw_b(:,:,1:34)),3);
b = testb;
g = testg-testb;
r = testr-testg;
r = r-min(r(:));
g = g-min(g(:));
b = b-min(b(:));
r = r./max(r(:));
g = g./max(g(:));
b = b./max(b(:));
r = log(r./max(r(:))+1);
g = log(g./max(g(:))+1);
b = log(b./max(b(:))+1);
r = adapthisteq(r);
g = adapthisteq(g);
b = adapthisteq(b);
r = medfilt2(r);
g = medfilt2(g);
b = medfilt2(b);
% r = imgaussfilt(r,1.1);
% g = imgaussfilt(g,1.1);
% b = imgaussfilt(b,1.1);
r = r-min(r(:));
g = g-min(g(:));
b = b-min(b(:));
r = r./max(r(:));
g = g./max(g(:));
b = b./max(b(:));
HSV = rgb2hsv(cat(3,r,g,b));
figure(2)
subplot(1,2,1)
imagesc(cat(3,r,g,b)+0.15); axis equal tight
%%%%%%
image = image-min(image(:));
image = image./max(image(:));
h = HSV(:,:,1);
s = HSV(:,:,2);
v = image;
figure(2)
subplot(1,2,2)
testimage = hsv2rgb(cat(3,h,s,v));
for i=1:3
    testimage(:,:,i) = testimage(:,:,i)-min(testimage(:,:,i));
    testimage(:,:,i) = testimage(:,:,i)./max(max(testimage(:,:,i)));
    testimage(:,:,i) = adapthisteq(testimage(:,:,i));
end

imagesc(testimage)
axis equal tight
