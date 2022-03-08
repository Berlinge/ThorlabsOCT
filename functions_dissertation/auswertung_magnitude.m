%% Darstellung unterschiedlicher Auswertungen eines B-scan Stacks
mag = abs(Raw(1:1024,:,:));

%% First and Mean / in progress
clc;
figure(1), clf(1)

image = 20.*log10(mag(:,:,1));
% image = (image-min(image(:)))./(max(image-min(image(:))));
subplot(1,2,1)
imagesc(image)
axis equal tight
colormap gray; colorbar
caxis([0 60])

image = 20.*log10(mean(mag,3));
% image = (image-min(image(:)))./(max(image-min(image(:))));
subplot(1,2,2)
imagesc(image)
axis equal tight
colormap gray; colorbar
caxis([0 60])

%% Mean and Std
clc;
figure(2), clf(2)

image = 20.*log10(mean(mag,3));
image = (image-min(image(:)))./max(max(image-min(image(:))));
subplot(1,2,1)
imagesc(image)
axis equal tight
colormap gray; colorbar

image = log(std(mag,0,3));
image = (image-min(image(:)))./max(max(image-min(image(:))));
subplot(1,2,2)
imagesc(image)
axis equal tight
colormap gray; colorbar

%% Mean and Pca
clc;
figure(3), clf(3)

image = 20.*log10(mean(mag,3));
image = (image-min(image(:)))./(max(image-min(image(:))));
subplot(1,2,1)
imagesc(image)
axis equal tight
colormap gray; colorbar

mag_pca = pca(reshape(permute(mag,[3 1 2]),[size(mag,3) size(mag,1)*size(mag,2)]));
mag_pca = reshape(mag_pca(:,:,:),[size(mag,1) size(mag,2) size(mag,3)-1]);
mag_pca = std(mag_pca(:,:,2:end),0,3);
mag_pca = medfilt2((mag_pca),[3 3]);
mag_pca = log(mag_pca+1);
mag_pca = (mag_pca-min(mag_pca(:)))./max(max(mag_pca-min(mag_pca(:))));

subplot(1,2,2)
imagesc(mag_pca)
axis equal tight
colormap gray; colorbar

%%
% positions for noise and signal ROI with contrast measure
z = 441:470;
x = 224:253;
z_noise = 254:283;
x_noise = 224:253;

clc;
figure(4), clf(4)

image = 20.*log10(mean(mag,3));
image = (image-min(image(:)))./(max(image-min(image(:))));
subplot(1,2,1)
imagesc(image)
axis equal tight
colormap gray; colorbar

hold on
rectangle('Position',[x(1) z(1) length(x) length(z)],'EdgeColor','black')
rectangle('Position',[x_noise(1) z_noise(1) length(x_noise) length(z_noise)],'EdgeColor','red')
hold off

mag_pca = pca(reshape(permute(mag,[3 1 2]),[size(mag,3) size(mag,1)*size(mag,2)]));
mag_pca = reshape(mag_pca(:,:,:),[size(mag,1) size(mag,2) size(mag,3)-1]);
mag_pca = std(mag_pca(:,:,2:end),0,3);
mag_pca = medfilt2((mag_pca),[3 3]);
mag_pca = log(mag_pca+1);
mag_pca = (mag_pca-min(mag_pca(:)))./(max(mag_pca-min(mag_pca(:))));

cont = std(image(z,x),0,'all')./mean(image(z,x),'all')
cont = std(mag_pca(z,x),0,'all')./mean(mag_pca(z,x),'all')

subplot(1,2,2)
imagesc(mag_pca)
axis equal tight
colormap gray; colorbar

hold on
rectangle('Position',[x(1) z(1) length(x) length(z)],'EdgeColor','black')
rectangle('Position',[x_noise(1) z_noise(1) length(x_noise) length(z_noise)],'EdgeColor','red')
hold off