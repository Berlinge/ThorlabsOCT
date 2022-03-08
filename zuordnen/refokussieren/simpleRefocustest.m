clc;
figure(2)
clf(2)
% A = ifft2(ifftshift(Vol(:,:,175)));
A = squeeze(Vol(:,:,175));
enface  = A; %(squeeze(Raw(400,:,:)));

subplot(2,2,1)
imagesc(log(abs(enface)))
axis equal tight

fft_enface = fftshift(fft2(enface));
fft_enface = circshift(circshift(fft_enface,225,1),50,2);
subplot(2,2,2)
imagesc(log(abs(log(abs(fft_enface)+1))+1))
axis equal tight
colormap gray

Zernike = zeros(size(fft_enface,1),size(fft_enface,2),1);
for i=1:1
    Zernike(:,:,i) = zernikePolN(i+3,size(fft_enface,1),size(fft_enface,2));
end
Zernike = 40.*sum(Zernike,3);
% Zernike = inf.Zernike(250,:);
% Zernike = repmat(Zernike,[size(fft_enface,1) 1]);

% Zernike = Zernike.*(abs(linspace(start_points(3),start_points(4),size(Zernike,1))'+start_points(2))*start_points(1));
% Zernike = circshift(Zernike,0,2);

subplot(2,2,3)
imagesc(Zernike)
axis equal tight

ref = fft_enface.*exp(-1i.*Zernike);
ref = ifft2(ifftshift(ref));
% ref = 
subplot(2,2,4)
imagesc(log(abs(ref)))
axis equal tight