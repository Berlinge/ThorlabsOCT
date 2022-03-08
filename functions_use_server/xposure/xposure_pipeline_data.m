%% Registrate Volume over time
fixed = partVol(:,:,:,1);
moving_reg = partVol;
moving_reg(:,:,:,1) = fixed;
for i=2:size(partVol,4)
moving = partVol(:,:,:,i);
[optimizer, metric] = imregconfig('monomodal');
moving_reg(:,:,:,i) = imregister(moving,fixed,'affine',optimizer,metric);
i
end
%% Registrate image distortion [alpha]
test = partVol;
for t=1:size(partVol,4)
    for i=2:2:size(partVol,3)
        fixed = squeeze(partVol(:,:,i-1,1));
        moving = squeeze(partVol(:,:,i,1));
        [optimizer, metric] = imregconfig('monomodal');
        test(:,:,i,t) = imregister(moving,fixed,'affine',optimizer,metric);
    end
    t
end
% test = cat(3,fixed,moving,fixed,image);
% implay(test)
%% Calculate Standard deviation
test = cumsum(moving_reg,4);
t = squeeze(test(:,:,:,end));
%%
image = squeeze(partVol(100,:,:,:));
image = squeeze(std(image,0,3));
image = imresize(image(:,1:2:end),[500 50]);
imagesc(log(image+1))
axis equal tight
colormap gray
%% Save into tiff File
clc;
options.color     = false;
options.compress  = 'no';
options.message   = true;
options.append    = false;
options.overwrite = true;
options.big       = true;
% upartVol = cast(partVol,'uint16');
res = saveTiffStack(reshape(test,[300 500 50*100]),[pwd,'\test3.tif'], options);

%% Frequency based dOCT
% Raw_b = abs(TRaw(:,:,1:end,:));
% Raw_b = fillmissing(Raw_b,'linear');
% Raw_b = unwrap(Raw_b,[],3);
Raw_b = abs(fft(abs(TRaw(:,:,1:end,:)),size(TRaw,4),4));
% Raw_b = Raw_b(:,:,:,:);
testb = sum(abs(Raw_b(:,:,:,1:1)),4);
testg = sum(abs(Raw_b(:,:,:,1:22)),4);
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
rr = imresize3(r(:,:,:),[size(r,1) size(r,2) size(r,3)]);
gg = imresize3(g(:,:,:),[size(g,1) size(g,2) size(g,3)]);
bb = imresize3(b(:,:,:),[size(b,1) size(b,2) size(b,3)]);
testerg = permute(cat(4,rr,gg,bb),[2 3 4 1]);
%%
for i=1:2:500
%     testerg(:,i,:,:) = circshift(testerg(:,i,:,:),-2,1);
    image(:,i,:) = squeeze(circshift(testerg(:,i,:,100),0,1));
end
imagesc(image);
%%
implay(testerg)