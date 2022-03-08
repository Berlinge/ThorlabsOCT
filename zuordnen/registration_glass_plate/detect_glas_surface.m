function [outputArg1,outputArg2] = detect_glas_surface(image)
figure(1),clf(1);
image = abs(angle(Raw(1:1024,:,1))-angle(Raw(1:1024,:,2)));
subplot(1,2,1)
imagesc(image); colormap gray; caxis([0 1]); axis equal tight
hold on
image = medfilt2(image,[5 5]); 
image = edge(image,[],'vertical','Canny');
image = mean(image,2);
k = 50;
image = -movmean(image(k:end-k),50); % ersten und letzten 100 Werte ignorieren
image = 10.^((image+1));
image = movmean(image,50);
image = diff(image);
subplot(1,2,2)
plot(image);
subplot(1,2,1)
[~,m] = max(image);
% m = 600; % set manual
m = m+k;
plot(linspace(1,size(Raw,2),size(Raw,2)),m.*ones(1,size(Raw,2)),'r.')
plot(linspace(1,size(Raw,2),size(Raw,2)),m.*ones(1,size(Raw,2)),'r.')
z = linspace(m-k,m+k,2*k+1);
end

