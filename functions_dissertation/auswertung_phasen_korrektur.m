clear all;
%%
load("Z:\Daten\2019-11-19 Zunge 28 Phasenkorrigiert mit Alg.mat")
%%
clc; 
Raw_diff_a = angle(Raw(1:1024,:,:));
Raw_n2_diff_a = angle(Raw_n2(1:1024,:,:));

% Raw_diff = diff(Raw_diff_a,1,3);
% Raw_n2_diff = diff(Raw_n2_diff_a,1,3);
% tol = pi/4;
% Raw_diff = unwrap(Raw_diff,tol,3);
% Raw_n2_diff = unwrap(Raw_n2_diff,tol,3);
% subplot(2,2,1)
% histogram(angle(Raw(:,:,1)))
% subplot(2,2,2)
% histogram(angle(Raw_n2(:,:,1)))
% subplot(2,2,3)
% histogram(Raw_diff(:,:,1))
% subplot(2,2,4)
% histogram(Raw_n2_diff(:,:,1))
%%
figure(1), clf(1),
for i=1:150-1
    corr(:,:,i) = Raw_n2(1:1024,:,i).*conj(Raw_n2(1:1024,:,i+1));
    uncorr(:,:,i) = Raw(1:1024,:,i).*conj(Raw(1:1024,:,i+1));
end
% histogram(angle(test));
imagesc(angle(corr(:,:,1)))
parula_wrap = vertcat(parula,flipud(parula));
colormap(parula_wrap);
axis equal tight
caxis([-pi pi])
colorbar

%% plot individual pixel ROIs
tic
clc;
figure(2), clf(2),

% positions for noise and signal ROI 
z = 441:450;
x = 224:233;
z_noise = 254:263;
x_noise = 224:233;

subplot(2,2,3)
imagesc(medfilt2(angle(corr(:,:,1))))
title(' ')
parula_wrap = vertcat(parula,flipud(parula));
colormap(parula_wrap);
axis equal tight
caxis([-pi pi])
colorbar
h = colorbar;
ylabel(h, 'phase')
hold on
rectangle('Position',[x(1) z(1) length(x) length(z)],'EdgeColor','black')
rectangle('Position',[x_noise(1) z_noise(1) length(x_noise) length(z_noise)],'EdgeColor','red')
hold off

subplot(2,2,1)
imagesc(medfilt2(angle(uncorr(:,:,1))))
title(' ')
parula_wrap = vertcat(parula,flipud(parula));
colormap(parula_wrap);
axis equal tight
caxis([-pi pi])
colorbar
h = colorbar;
ylabel(h, 'phase')
hold on
rectangle('Position',[x(1) z(1) length(x) length(z)],'EdgeColor','black')
rectangle('Position',[x_noise(1) z_noise(1) length(x_noise) length(z_noise)],'EdgeColor','red')
hold off

subplot(2,2,4)
plot(squeeze(mean(mean(angle(corr(z,x,:)),1),2)),'k')
hold on
plot(squeeze(mean(mean(angle(corr(z_noise,x_noise,:)),1),2)),'r')
hold off
ylim([-pi pi])

subplot(2,2,2)
plot(squeeze(mean(mean(angle(uncorr(z,x,:)),1),2)),'k')
hold on
plot(squeeze(mean(mean(angle(uncorr(z_noise,x_noise,:)),1),2)),'r')
hold off
ylim([-pi pi])

toc
%% plot histograms of images and ROIs over time
clc;
figure(3), clf(3),

subplot(2,2,1)
histogram(angle(corr(:,:,1)))
xlim([-pi pi])

subplot(2,2,2)
histogram(angle(uncorr(:,:,1)))
xlim([-pi pi])

subplot(2,2,3)
polarhistogram(squeeze(angle(corr(400,200,:))),50);

subplot(2,2,4)
polarhistogram(squeeze(angle(uncorr(400,200,:))),50);

%%
figure(4)
subplot(1,2,1)
polarhistogram(squeeze(angle(corr(900,200,:))),50);

subplot(1,2,2)
polarhistogram(squeeze(angle(uncorr(900,200,:))),50);
%% display std if phase
imagesc(std(angle(corr),0,3))

%%
histogram(angle(corr(:,:,1)))
