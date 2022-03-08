% Rawt = Raw(1:sizeZ,:,1:200);

Rawt = abs(squeeze(TRaw(:,:,101,:)));
clc;
test = pca(reshape(permute(abs(Rawt),[3 1 2]),[size(Rawt,3) size(Rawt,1)*size(Rawt,2)]));
% test = pca(reshape(permute(unwrap(angle(Raw_02(1:1024,:,:)),[],3),[3 1 2]),[150 1024*500]));
test_image = reshape(test(:,:,:),[size(Rawt,1) size(Rawt,2) size(Rawt,3)-1]);
test_image = var(test_image(:,:,2:end),0,3);
figure(1)
imagesc(test_image)
figure(2)
%
imagesc(log(std(abs(Rawt),0,3)))

%%
for y=1:500
    Rawt = abs(squeeze(TRaw(:,:,y,:)));
    test = pca(reshape(permute(abs(Rawt),[3 1 2]),[size(Rawt,3) size(Rawt,1)*size(Rawt,2)]));
    % test = pca(reshape(permute(unwrap(angle(Raw_02(1:1024,:,:)),[],3),[3 1 2]),[150 1024*500]));
    test_image = reshape(test(:,:,:),[size(Rawt,1) size(Rawt,2) size(Rawt,3)-1]);
    test_image = var(test_image(:,:,2:end),0,3);
    pcaRaw(:,:,y) = test_image;
    y
end
pcaRaw = log(pcaRaw+1);
pcaRaw = pcaRaw-min(pcaRaw(:));
pcaRaw = pcaRaw./max(pcaRaw(:));
pcaRaw = pcaRaw(:,:,1:2:end);
pcaRaw = imresize3(pcaRaw,[size(TRaw,1) size(TRaw,2) size(TRaw,3)]);
%%
pcaRaw = log(pcaRaw+1);
%%
pcaRaw = pcaRaw-min(pcaRaw(:));
pcaRaw = pcaRaw./max(pcaRaw(:));
h = implay((permute(pcaRaw(:,:,:),[2 3 1])));
h.Visual.ColorMap.UserRange = true;
h.Visual.ColorMap.UserRangeMax = 1;
%%
options.color     = false;
options.compress  = 'no';
options.message   = true;
options.append    = false;
options.overwrite = true;
options.big       = true;
res = saveTiffStack(permute((pcaRaw(:,:,:)),[1 2 3]),['std.tif'], options);

%%
clc;
for y=1:500
    HSV = rgb2hsv(cat(3,rr(:,:,y),gg(:,:,y),bb(:,:,y)));
    HH = HSV(:,:,1);
    SS = HSV(:,:,2);
    VV = pcaRaw(:,:,y);
    bla(:,:,y,:) = hsv2rgb(cat(3,HH,SS,VV));
end
%%
options.color     = true;
options.compress  = 'no';
options.message   = true;
options.append    = false;
options.overwrite = true;
options.big       = true;
res = saveTiffStack(permute(bla(:,:,:,:),[1 2 4 3]),['xposure_rgb.tif'], options);