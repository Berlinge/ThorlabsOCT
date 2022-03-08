figure(3), clf(3)
image = 20.*log10(abs(R));
image = log10(abs(fftshift(fft(image,500,2),2)));
image = (image-min(image(:)))./max(image(:)-min(image(:)));
imagesc(image);
axis equal tight
colormap gray
title('MTF')

% imagewsc(ima