clc;
% input [z x y t]
% pca for volumes
Raw = TRaw(:,:,1:2:end,:);
z = size(Raw,1);
x = size(Raw,2);
y = size(Raw,3);
t = size(Raw,4);
Raw = pca(reshape(permute(abs(Raw),[4 1 2 3]),[t z*x*y]));
Raw = reshape(Raw,[z x y t-1]);
Raw = nanstd(Raw(:,:,:,2:end),0,4);
Raw = squeeze(Raw);
Raw = log(Raw+1);
Raw = Raw-min(Raw(:));
Raw = Raw./max(Raw(:));
implay(medfilt3(permute(imresize3(Raw,[z x y*2]),[2 3 1]),[3 3 3]));
%
%% Frequency based dOCT
Raw_b = abs(TRaw(:,:,1:2:end,:));
% Raw_b = fillmissing(Raw_b,'linear');
% Raw_b = unwrap(Raw_b,[],3);
Raw_b = fft(Raw_b,size(Raw_b,4),4);
Raw_b = Raw_b(:,:,:,:);
testb = sum(abs(Raw_b(:,:,:,1:1)),4);
testg = sum(abs(Raw_b(:,:,:,1:32)),4);
testr = sum(abs(Raw_b(:,:,:,1:50)),4);
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
%
for y=1:size(r,3)
r(:,:,y) = adapthisteq(r(:,:,y));
g(:,:,y) = adapthisteq(g(:,:,y));
b(:,:,y) = adapthisteq(b(:,:,y));
end
r = medfilt3(r);
g = medfilt3(g);
b = medfilt3(b);
% r = imgaussfilt(r,1.1);
% g = imgaussfilt(g,1.1);
% b = imgaussfilt(b,1.1);
r = r-min(r(:));
g = g-min(g(:));
b = b-min(b(:));
r = r./max(r(:));
g = g./max(g(:));
b = b./max(b(:));
rr = imresize3(r(:,:,:),[size(r,1) size(r,2) 2*size(r,3)]);
gg = imresize3(g(:,:,:),[size(g,1) size(g,2) 2*size(g,3)]);
bb = imresize3(b(:,:,:),[size(b,1) size(b,2) 2*size(b,3)]);
testerg = permute(cat(4,rr,gg,bb),[2 3 4 1]);
implay(testerg)
% HSV = rgb2hsv(cat(3,r,g,b));
% figure(2)
% subplot(1,2,1)
% imagesc(cat(3,r,g,b)+0.15); axis equal tight
%%%%%%
% image = image-min(image(:));
% image./max(image(:));
% h = HSV(:,:,1);
% s = HSV(:,:,2);
% v = image;
% figure(2)
% subplot(1,2,2)
% testimage = hsv2rgb(cat(3,h,s,v));
% % for i=1:3
%     testimage(:,:,i) = testimage(:,:,i)-min(testimage(:,:,i));
%     testimage(:,:,i) = testimage(:,:,i)./max(max(testimage(:,:,i)));
%     testimage(:,:,i) = adapthisteq(testimage(:,:,i));
% end

% imagesc(testimage)
% axis equal tight
%% save
options.color     = true;
options.compress  = 'no';
options.message   = true;
options.append    = false;
options.overwrite = true;
options.big       = true;

res = saveTiffStack(permute(b(:,:,:,:),[1 2 3 4]),['c.tif'], options);