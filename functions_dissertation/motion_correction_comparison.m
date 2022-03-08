
%% Gegenüberstellung Phase korrigiert und unkorrigiert

figure(1); clf(1);
imagesc(medfilt2(std(angle(Raw_n2(1:1024,:,:)),0,3))); axis equal tight; colorbar
figure(2); clf(2);
imagesc(medfilt2(std(angle(Raw(1:1024,:,:)),0,3))); axis equal tight; colorbar

%% Auswertung der Phasen in 2 ROIs 

z_roi = [446:455];
x_roi = [246:255];
p = angle(Raw_n2(z_roi,x_roi,:));

z_roi_noise = [346:355];
x_roi_noise = [246:255];
n = angle(Raw_n2(z_roi_noise,x_roi_noise,:));

figure(3); clf(3)
subplot(2,2,1)
imagesc(medfilt2(std(angle(Raw_n2(1:1024,:,:)),0,3))); axis equal tight; colorbar
hold on 
rectangle('Position',[x_roi(1) z_roi(2) length(x_roi) length(z_roi)],'EdgeColor','r')
rectangle('Position',[x_roi_noise(1) z_roi_noise(2) length(x_roi_noise) length(z_roi_noise)],'EdgeColor','w')
hold off
title('Std')

subplot(2,2,2)
imagesc(medfilt2(mean(angle(Raw_n2(1:1024,:,:)),3))); axis equal tight; colorbar
title('Mean')

subplot(2,2,3)
plot(squeeze(mean(mean(p,1),2)));
title(['Red / Cells std: ',num2str(std(mean(mean(p,1),2),0,3))]);

subplot(2,2,4)
plot(squeeze(mean(mean(n,1),2)));
title(['White / Noise std: ',num2str(std(mean(mean(n,1),2),0,3))]);
