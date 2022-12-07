clear variables; clc;

usaf = double(imread("E:\OneDrive\Desktop\test\USAF-1951.svg.png"));
image = double(rgb2gray(imread("E:\OneDrive\Desktop\test\image.jpg")));
image = image./50;
image(301:600,1:300) = image(301:600,1:300).*exp(1i.*rand(300,300));
%image = usaf;

psf_image = double(rgb2gray(imread("E:\OneDrive\Desktop\test\psf.jpg")));

psf = psf_image; 

inc_image = fftshift(fft2(image)).*(fft2(psf));
inc_image = ifft2(inc_image);
inc_image = conv2(image,psf.^2,'same');

[X,Y] = meshgrid(-1000:1000,-1000:1000);
NA = zeros(size(X));
NA(sqrt(X.^2+Y.^2)<300) = 1;
NA = imresize(NA,[size(psf,1) size(psf,2)]);

% psf = angle(ifft2(fft2(psf)));
psf = angle(psf);

coh_image = conv2(image,psf,'same');

figure(1)
colormap gray

subplot(2,4,[1 5])
imagesc(abs(image))
axis equal tight

subplot(2,4,[2])
imagesc(abs(psf))
axis equal tight

subplot(2,4,[6])
imagesc(angle(psf))
axis equal tight

subplot(2,4,3)
imagesc((abs(inc_image)))
axis equal tight
title('Incoherent')

subplot(2,4,7)
imagesc(abs(coh_image))
axis equal tight
title('Coherent')

