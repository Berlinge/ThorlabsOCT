clearvars -except slice
clc;
% slice = squeeze(TRaw(89,:,:,:));
% slice = slice(:,1:2:end,:);
% slice = imresize3(slice,[500 500 100]);
imagesc(std(abs(slice),0,3))
%
p = 10;
clc;
xx = 50;
yy = 50;
Vq = zernikePolN(4,30,30);
Vq = padarray(Vq,[p+10 p+10]);
%Vq = zernikef(0,1,500)
imagesc(Vq);
for k=0
    k = -k;
    for i=1:100
        test = squeeze(slice(:,:,i));
        test = fftshift(fft2(test));
        for x=1:50:500
            for y=1:50:500
                roi = test(x:x+xx-1,y:y+yy-1);
                roi = padarray(roi,[p p]);
                roi = roi.*exp(-1i.*k.*Vq);
                roi = roi(p+1:p+1+xx-1,p+1:p+1+yy-1);
                test(x:x+xx-1,y:y+yy-1) = roi;
            end
        end
        test = ifft2(ifftshift(test));
        test = abs(test);
        rslice(:,:,i) = test;
    end
%     imagesc(log(std(rslice,0,3)+1))
    imagesc((std(rslice,0,3)))
    axis equal tight
    pause(0.1)
end