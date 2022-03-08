clc;
input = abs(Raw(1:1024,:,:));
% Pfade zu den Datensätzen ergänzen
% "Z:\Daten\2019-11-19 Zunge 28 Phasenkorrigiert mit Alg.mat" Zunge
% Datensatz: 20191219_6_0014_Mode2D_inf.mat
% 

z = [401:500]; % Zunge und Leber
% z = [360:450]; % Trachea

colormap gray
figure(1); clf(1);
% Mittelwert
output = 20*log10(mean(input,3));
subplot(2,4,1)
imagesc(output)
caxis([0 60])
colorbar
daspect([1 (1024/860)*1.3 1]) % axis equal tight
subplot(2,4,5)
fft_output = log(abs(fftshift(fft(output,500,2),2)));
fft_output = fft_output - min(fft_output(:)); 
fft_output = fft_output./max(fft_output(:));
fft_o(:,1) = mean(fft_output(z,:),1);
imagesc(fft_output)
colorbar
daspect([1 (1024/860)*1.3 1]) % axis equal tight
% Standardabweichung
output = log(std(input,0,3)); output = output-min(output(:)); output = output./max(output(:));
subplot(2,4,2)
imagesc(output)
colorbar
daspect([1 (1024/860)*1.3 1]) % axis equal tight
subplot(2,4,6)
fft_output = log(abs(fftshift(fft(output,500,2),2)));
fft_output = fft_output - min(fft_output(:)); 
fft_output = fft_output./max(fft_output(:));
fft_o(:,2) = mean(fft_output(z,:),1);
imagesc(fft_output)
colorbar
daspect([1 (1024/860)*1.3 1]) % axis equal tight
% PCA
output = calc_dOCT_pca(input);
subplot(2,4,3)
imagesc(output)
colorbar
daspect([1 (1024/860)*1.3 1]) % axis equal tight
subplot(2,4,7)
fft_output = log(abs(fftshift(fft(output,500,2),2)));
fft_output = fft_output - min(fft_output(:)); 
fft_output = fft_output./max(fft_output(:));
fft_o(:,3) = mean(fft_output(z,:),1);
imagesc(fft_output)
colorbar
daspect([1 (1024/860)*1.3 1]) % axis equal tight
% FFT
output = rgb2gray(calc_dOCT_fft(input,108));
subplot(2,4,4)
imagesc(output)
colorbar
daspect([1 (1024/860)*1.3 1]) % axis equal tight
subplot(2,4,8)
fft_output = log(abs(fftshift(fft(output,500,2),2)));
fft_output = fft_output - min(fft_output(:)); 
fft_output = fft_output./max(fft_output(:));
fft_o(:,4) = mean(fft_output(z,:),1);
imagesc(fft_output)
colorbar
daspect([1 (1024/860)*1.3 1]) % axis equal tight

figure(2); clf(2)
plot(fft_o)
legend('mean','std','pca','fft')

 set(gca, 'FontName', 'Arial','FontSize','8')
 