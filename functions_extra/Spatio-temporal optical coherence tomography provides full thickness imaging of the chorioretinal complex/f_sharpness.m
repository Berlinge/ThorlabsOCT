function [sharpness] = f_sharpness(a,B_scan)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
b(1) = 0;
b(2) = 0;
o = linspace(-pi,pi,1024); % o = linspace(2*pi/(-37.5*10^-9),2*pi/(37.5*10^-9),1024);
phase = (b(1).*o+b(2).*o.^2+a(1).*o.^3+a(2).*o.^4./100+a(3)*o.^5./100);
image = 20.*log10(abs(ifft(B_scan.*exp(1i.*phase),1024,2)));
image = imrotate(image,90);
sharpness = -entropy(image(51:150,:));
sharpness = -max(max(image(51:150,:)));

figure(1); colormap gray
subplot(2,2,3:4)
plot(phase)
subplot(2,2,2)
imagesc(image)
axis equal tight
pause(0.01)

end

