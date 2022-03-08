clc; clearvars -except Raw
%% Axial image registration based on phase information
clc;
%z = [180:290];
l = 10;
for i=2:size(Raw,3)
    xx = 1;
    for x=1:l:500 
        image1 = Raw_n(:,x:x+l-1,1); % i-1
        image2 = Raw_n(:,x:x+l-1,i);
        fimage2 = fft(image2,size(image2,1),1);
        points = [0 0];
        func = @(points)  f_reg(image1,fimage2,z,points);
        output(i-1,xx:xx+2-1) = fminsearch(func,points);
        xx = xx+2;
    end
    i
end
%% registrate the phase with optimized phased based change
Raw_n2 = Raw_n;
for i=2:size(Raw,3)
    xx = 1;
    for x=1:l:500
        points = output(i-1,xx:xx+1)*20000;
        imagen = Raw_n(:,x:x+l-1,i);
        fimagen = fft(imagen,2048,1);
        phase = repmat(linspace(0+points(1),points(1)+points(2),2048)',1,l);
        fimagen = fimagen.*exp(1i*phase);
        imagen = ifft(fimagen,2048,1);
        Raw_n2(:,x:x+l-1,i) = imagen;
        xx = xx+2;
    end
end
% z = 300:360;
%% Display results
implay(angle(Raw_n2(z,:,:)))
implay(octa(Raw_n2(z,:,:)))
% implay(angle(Raw_n(1:1024,:,:)))
% implay(abs(Raw_n(1:1024,:,:)))
%% Compare it with original one
implay(angle(Raw(z,:,:)))
implay(octa(Raw(z,:,:)))
%% Optional - Relative changes to glas plate
y = round(linspace(333,320,500));
Raw_d = angle(Raw_n(1:1024,:,:));
for i=1:size(Raw_n,3)
    for x=1:size(Raw_n,2)
        Raw_d(:,x,i) = Raw_d(:,x,i)-Raw_d(y(x),x,i);
    end
end
imagesc(std(unwrap(Raw_d,[],3),0,3));
axis equal tight
%% Display std of phase and abs
subplot(1,2,1)
image = std(abs(Raw(1:1024,:,:)),[],3);
imagesc(medfilt2(image,[3 3]));
caxis([0 80])
colorbar
axis equal tight
subplot(1,2,2)
image = std(unwrap(angle(Raw_n2(1:1024,:,:)),1/16*pi,3),0,3);
imagesc(medfilt2(image,[3 3]));
caxis([0 5])
colorbar
axis equal tight
%% Optional - dOCT - fast mode
Raw_b = unwrap(angle(Raw_n2(:,:,:)),[],3);
Raw_b = fft(Raw_b,size(Raw_b,3),3);
Raw_b = Raw_b(1:1024,:,:);
testb = sum(abs(Raw_b(:,:,1:1)),3);
testg = sum(abs(Raw_b(:,:,1:34)),3);
testr = sum(abs(Raw_b(:,:,1:75)),3);
b = testb;
g = testg-testb;
r = testr-testg;
r = r-min(r(:));
g = g-min(g(:));
b = b-min(b(:));
r = r./max(r(:));
g = g./max(g(:));
b = b./max(b(:));
r = log(r./max(r(:))+1);
g = log(g./max(g(:))+1);
b = log(b./max(b(:))+1);
% r = adapthisteq(r);
% g = adapthisteq(g);
% b = adapthisteq(b);
% r = medfilt2(r);
% g = medfilt2(g);
% b = medfilt2(b);
% r = imgaussfilt(r,1.1);
% g = imgaussfilt(g,1.1);
% b = imgaussfilt(b,1.1);
r = r-min(r(:));
g = g-min(g(:));
b = b-min(b(:));
r = r./max(r(:));
g = g./max(g(:));
b = b./max(b(:));
imagesc(cat(3,r,g,b)+0.5); axis equal tight
%% function for optimization / registration of phases
function [output] = f_reg(image1,fimage2,z,points)
points = points*20000;
phase = repmat(linspace(0+points(1),points(1)+points(2),size(fimage2,1))',1,size(fimage2,2));
fimage2n = fimage2.*exp(1i*phase);
image2 = ifft(fimage2n,size(image1,1),1);
d = abs(angle(image2)-angle(image1));
d = d(1:1024,:);

% subplot(1,2,1)
%         %plot(d(z,500));
% imagesc(d(z,:))
% colorbar
% axis equal tight
% title([num2str(points)])
% caxis([0 10])
% subplot(1,2,2)
% imagesc(d)
% colorbar
% axis equal tight
% caxis([0 10])
% pause(0.01)

T = sum(d(z+100,:),'all');
%T(k) = trapz(d(z,:));
%T(k) = sum(d(z,500));
%T(k) = max(max(abs(corr2(angle(image1),angle(image2)))));
output = min(T);
end
