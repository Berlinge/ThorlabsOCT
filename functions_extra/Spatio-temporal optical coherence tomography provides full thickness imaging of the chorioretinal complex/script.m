clear variables; clc; close all;
%
% fileID = fopen('mozaika2/000-6do_20201023 150138/20201023 150138-31.mraw');
fileID = fopen('mozaika4/000-6b_20201023 155123/20201023 155123-01.mraw');
I = fread(fileID,2*512*512*512*2,'uint16=>uint16','ieee-le');
I = reshape(double(I),[512 512 512]);
fclose(fileID);
clear fileID ans;
%% Visualization
video = implay(I);
video.Visual.ColorMap.UserRange = 1; video.Visual.ColorMap.UserRangeMin = 0; video.Visual.ColorMap.UserRangeMax = 2000;
%
figure(1); clf(1)
colormap gray
imagesc(log(abs(fftshift(fft2(I(:,:,1))))))
clear video
%% DC subtraction
% m = mean(I,3);
% for lambda=1:512
%     I(:,:,lambda) = I(:,:,lambda)-m;
% end
for x=1:512
    for y=1:512
        mova = movmean(squeeze(I(x,y,:)),10);
        I(x,y,:) = squeeze(I(x,y,:))-mova; 
    end
end
figure(1); clf(1);
hold on
plot(squeeze(I(100,100,:)))
%% Apodization
w = hann(512);
for x=1:512
    for y=1:512
        I(x,y,:) = squeeze(I(x,y,:)).*w;    
    end
end
figure(1);
plot(squeeze(I(100,100,:)))
hold off
clear c x y mova  w
%% Fourier-Transform
I_fft = fft(I,2048,3);
I_fft = I_fft(:,:,1:1024);
%% Spatial frequency filtering
for i=1:1024
    I_fft2(:,:,i) = fftshift(fft2(I_fft(:,:,i)));
end
clear i
%% Visualization
figure(1); clf(1); colormap gray;
imagesc(log(sum(abs(I_fft2),3)))
axis equal tight
%% Filter circles
% [centers,radii,metric] = imfindcircles(log(sum(abs(I_fft2),3)),[15 130]);
% if center < 256-150 %   is ok % end
radius = 20; SizeX = 512; SizeY = 512;
[X, Y] = meshgrid(1:SizeX, 1:SizeY);
centerX = 256; centerY = 256;
circle = (Y - centerY).^2 + (X - centerX).^2 <= radius.^2;
mask = ~circle;
%
for i=1:1024
    V(:,:,i) = ifft2(ifftshift(I_fft2(:,:,i).*mask));
end
clear circle1 circle2 circle3 radius SizeX SizeY mask Y X radii metric i circle centerX centerY centers
%% Visualization (xy through z)
video = implay(20.*log10(abs(V)));
video.Visual.ColorMap.UserRange = 1; video.Visual.ColorMap.UserRangeMin = 0; video.Visual.ColorMap.UserRangeMax = 100; video.Visual.Magnification.AutoGrow = 1;
%% Visualization (xz through y)
video = implay(flipud(permute(20.*log10(abs(V)),[3 1 2])));
video.Visual.ColorMap.UserRange = 1; video.Visual.ColorMap.UserRangeMin = 0; video.Visual.ColorMap.UserRangeMax = 100; video.Visual.Magnification.AutoGrow = 1;
%% Visualization (yz through x)
video = implay(flipud(permute(20.*log10(abs(V)),[3 2 1])));
video.Visual.ColorMap.UserRange = 1; video.Visual.ColorMap.UserRangeMin = 0; video.Visual.ColorMap.UserRangeMax = 100; video.Visual.Magnification.AutoGrow = 1;
%% Visualization
figure(1); clf(1); colormap gray
subplot(2,2,1)
imagesc(imrotate(20.*log10(abs(squeeze(V(256,:,:)))),90));
clim([0 150])
axis equal tight
%% Dispersion compensation // iterativer Ansatz wäre besser; erst a(1) optimieren, danach a(2), usw.
clc;
D = fft(V,1024,3);
B_scan = squeeze(D(256,:,:));
% Optimization
fun = @(a) f_sharpness(a,B_scan);
a = [0; 0; 0];
options = optimoptions('fminunc','Algorithm','quasi-newton','CheckGradients',false, ...
    'FiniteDifferenceStepSize',10^16,'OptimalityTolerance',10^-10000,'DiffMinChange',0.0001,'DiffMaxChange',0.001);
options.Display = 'iter';
[a, fval, exitflag, output, grad] = fminunc(fun,a,options);
clear output exitflag fval fun options
%% Dispersion correction for all B-scans
b(1) = 0;
b(2) = 0;
o = linspace(-pi,pi,1024); % o = linspace(2*pi/(-37.5*10^-9),2*pi/(37.5*10^-9),1024);
phase = (b(1).*o+b(2).*o.^2+a(1).*o.^3+a(2).*o.^4./100+a(3)*o.^5./100);
for x=1:512
    D(x,:,:) = squeeze(D(x,:,:)).*exp(1i.*phase);
end
Erg = ifft(D,1024,3);
clear b o phase
%% defocus via split aperture method

%% Digital aberration correction
% Display the Zernike function Z(n=5,m=1)
x = -1:0.01:1;
[X,Y] = meshgrid(x,x);
[theta,r] = cart2pol(X,Y);
idx = r<=1;
z = nan(size(X));
z(idx) = zernfun(2,0,r(idx),theta(idx));
figure(2); clf(2)
imagesc(z)
axis equal tight
z = imresize(z,[512 512]);
%%
z(isnan(z)) = 0;
test = ifft2(ifftshift(fftshift(fft2(squeeze(Erg(:,:,500)))).*exp(1i.*10.*z)));
figure(2); clf(2); colormap gray
imagesc(20.*log10(abs(test)))
axis equal tight
%% Layer segmentation