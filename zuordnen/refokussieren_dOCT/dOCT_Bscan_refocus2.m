function [] = dOCT_Bscan_refocus(path,file,function_name)
% Experimental - does not work 

for k=-20:60
start_points = [k 0 -2.2 3]; % sp z y1 y2
inf.Zernike = zeros(size(fftimage,1),size(fftimage,2),1);
for i=1:1
    inf.Zernike(:,:,i) = zernikePolN(i+3,size(fftimage,1),size(fftimage,2));
end
inf.Zernike = sum(inf.Zernike,3);
Zernike = inf.Zernike(250,:);
Zernike = repmat(Zernike,[size(fftimage,1) 1]);

Zernike = Zernike.*(abs(linspace(start_points(3),start_points(4),size(Zernike,1))'+start_points(2))*start_points(1));
Zernike = circshift(Zernike,150,2);
RawR = Raw;

for i=1:150
    test = RawR(:,:,i);
    test = fftshift(fft(test,size(test,2),2),2);
    test = test.*exp(-1i.*Zernike);
    test = ifft(ifftshift(test,2),size(test,2),2);
    RawR(:,:,i) = test;
end

figure(4)
subplot(1,2,2)
img = log(std(abs(RawR),0,3));
imagesc(img)
% caxis([-20 100])
colormap gray
axis equal tight

subplot(1,2,1)
imagesc(Zernike)

imwrite(img./(max(img(:))),[num2str(k),'_output.png'])

RawR = fft(abs(RawR),size(RawR,3),3);
RawR = RawR(201:900,:,:);

testb = sum(abs(RawR(:,:,1:1)),3);
testg = sum(abs(RawR(:,:,1:80)),3);
testr = sum(abs(RawR(:,:,1:size(RawR,3))),3);

b = testb;
g = testg-testb;
r = testr-testg;

r = r-min(r(:));
g = g-min(g(:));
b = b-min(b(:));

r = log(r./max(r(:))+1);
g = log(g./max(g(:))+1);
b = log(b./max(b(:))+1);

r = adapthisteq(r);
g = adapthisteq(g);
b = adapthisteq(b);

r = medfilt2(r);
g = medfilt2(g);
b = medfilt2(b);

c = cat(3,r,g,b);
imwrite(c,[num2str(k),'_rgb_output.png'])
end
% start_points = [0 0 -1 1]; % sp z y1 y2
% test = std(abs(RawR),0,3);
% test = fftshift(fft(test,size(test,2),2),2);
% % test = test.*exp(1i*angle(Raw(:,:,1)));
% test = ifft(ifftshift(test,2),size(test,2),2);
% Zernike = Zernike.*(abs(linspace(start_points(3),start_points(4),size(Zernike,1))'+start_points(2))*start_points(1));
% test = fftshift(fft(test,size(test,2),2),2);
% test = test.*exp(-1i.*Zernike);
% test = ifft(ifftshift(test,2),size(test,2),2);
% 
% figure(5)
% imagesc(abs(test))
% colormap gray
% axis equal tight