for i=100
enface_t = squeeze(OCT(i,:,:,:));

d_enface = log(std(abs(enface_t ),0,3));
enface = log(abs(enface_t(:,:,1)));

OTF = log(abs(fftshift(fft2((squeeze(enface_t(:,:,1)))))));
OTF = OTF-min(OTF(:));
OTF = OTF./max(OTF(:));
MTF = log(abs(fftshift(fft2(abs(squeeze(enface))))));
MTF = MTF-min(MTF(:));
MTF = MTF./max(MTF(:));
MTF_d = log(abs(fftshift(fft2(abs(squeeze(d_enface))))));
MTF_d = MTF_d-min(MTF_d(:));
MTF_d = MTF_d./max(MTF_d(:));

figure(1); clf(1)

subplot(4,3,1)
imagesc(enface)
colormap gray
axis equal tight
title('OCT enface')
ylabel('x')
xlabel('y')

subplot(4,3,3)
imagesc(d_enface)
colormap gray
axis equal tight
title('dOCT enface')
ylabel('x')
xlabel('y')

subplot(4,3,4)
imagesc(OTF)
colormap gray
axis equal tight
title('OTF')
ylabel('x')
xlabel('y')

subplot(4,3,5)
imagesc(MTF)
colormap gray
axis equal tight
title('MTF')
ylabel('x')
xlabel('y')

subplot(4,3,6)
imagesc(MTF_d)
colormap gray
axis equal tight
title('MTF')
ylabel('x')
xlabel('y')

subplot(4,3,8)
plot(mean(MTF(241:260,:),1))
colormap gray
% axis equal tight
% title('MTF')
% ylabel('x')
% xlabel('y')

subplot(4,3,9)
plot(mean(MTF_d(241:260,:),1))
colormap gray
% axis equal tight
% title('MTF')
% ylabel('x')
% xlabel('y')

subplot(4,3,12)
plot(mean(MTF(241:260,:),1))
hold on
plot(mean(MTF_d(241:260,:),1))
colormap gray
% axis equal tight
% title('MTF')
% ylabel('x')
% xlabel('y')

pause(1)
end