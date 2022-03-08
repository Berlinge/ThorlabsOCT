Raw_z = abs(Raw(300:600,:,:));
figure(1)
clf(1)
subplot(3,2,1)
imagesc(octa(Raw_z(:,:,1)))
title('OCT B-Scan (1 von 150)')
colormap gray
axis equal tight
subplot(3,2,3)
imagesc((squeeze(std(octa(Raw_z(:,:,:)),0,3))))
title('Std OCT Stack')
axis equal tight
subplot(3,2,5)
imagesc(squeeze(mean(octa(Raw_z(:,:,:)),3)))
title('Mean OCT Stack')
axis equal tight
subplot(3,2,2)
imagesc((Raw_z(:,:,1)))
title('B-Scan Intensitaets (1 von 150)')
axis equal tight
subplot(3,2,4)
imagesc(log(squeeze(std((Raw_z(:,:,:)),0,3))))
title('Std - Intensitaet Stack')
axis equal tight
subplot(3,2,6)
imagesc((dOCT(Raw_z(:,:,:),0)))
title('Frequenzbasiert - Intensitaets Stack')
axis equal tight
