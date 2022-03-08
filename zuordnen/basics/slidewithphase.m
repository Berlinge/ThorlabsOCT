%% slide through z with phase and visualize it with phase plot and imagesc
zI = [300:360];
image = Raw(:,:,1);
k = 1;
t = -10:0.01:10;
fimageb = fft(image,2048,1);
figure(1)
for k=-pi:0.01:pi
for ii=0; %0:1:1*2*pi
% ii=i;
% fimage = fft(Raw(:,:,1),2048,1);
% k = 1000;
phase = repmat(linspace(0+k,ii+k,2048)',1,500);
fimage = fimageb.*exp(1i*phase);
image = ifft(fimage,2048,1);

z=325;
x=400;
subplot(1,3,1)
imagesc(abs(image(zI,:)));
subplot(1,3,2)
imagesc(angle(image(zI,:)));
hold on
plot(x,z,'rx')
plot(x,z-100,'rx');
hold off
subplot(1,3,3)
polarplot(angle(image(z,x)),10,'*')
pause(0.001);
end
end