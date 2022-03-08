clc;
a = testerg;
for i=1:2:size(testerg,2)
    a(:,i,:,:) = circshift(a(:,i,:,:),8,1);
end

b = testerg;
for z=1:300
    hdinterlacer = vision.Deinterlacer('Method','Line repetition'); % 'Line repetition' (default) | 'Linear interpolation' | 'Vertical temporal median filtering'
    image = pagetranspose(a(:,:,:,z));
    image = hdinterlacer(image);
    b(:,:,:,z) =  pagetranspose(image);
end
% for i=1:3
%     a(:,:,i,:) = medfilt3(squeeze(a(:,:,i,:)));
% end
for i=1:3
    b(:,:,i,:) = medfilt3(squeeze(b(:,:,i,:)));
end
figure(1), clf(1);
imagesc(squeeze(a(:,:,:,115)))
figure(2), clf(2)
imagesc(squeeze(b(:,:,:,115)))
implay(b)
%% Image brightness
image = squeeze(b(100,:,:,:));
image = double(image);
ConfocalGating = squeeze(mean(mean(image,1),2));
ConfocalGating = ConfocalGating/max(ConfocalGating);
z = linspace(1,size(image,3),size(image,3))';
%Fit:
sigma = 1;
[xData, yData] = prepareCurveData( z, ConfocalGating );
% Set up fittype and options.
ft = fittype( 'gauss1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0];
opts.StartPoint = [1 415 94.2303557280076];
% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
val = coeffvalues(fitresult);
val(3) = val(3)*sigma;
ConfocalGating_Fit = (val(1).*exp(-((z-val(2))/val(3)).^2));
ConfocalGating_Fit = ConfocalGating_Fit/max(ConfocalGating_Fit);
% figure(1);plot(ConfocalGating_Fit); drawnow
%
clc;
mask1 = permute(repmat(ConfocalGating_Fit,1,size(testerg,1),size(testerg,2),3),[2 3 4 1]);
mask2 = permute(repmat(1-ConfocalGating_Fit,1,size(testerg,1),size(testerg,2),3),[2 3 4 1]);
h = 3;
testerg2 = b.*mask1 + b.*h.*mask2;
imagesc(permute(squeeze(testerg2(:,1,:,:)),[3 1 2]))
%% save option
options.color     = true;
options.compress  = 'no';
options.message   = true;
options.append    = false;
options.overwrite = true;
options.big       = true;

res = saveTiffStack(permute(testerg2,[1 2 3 4]),['b.tif'], options);


%%

clc;
oct2 = permute(oct,[2 3 1]);
for i=1:2:size(testerg,2)
    oct2(:,i,:) = circshift(oct2(:,i,:),0,1);
end
imagesc(octa(oct2(:,:,100)))
colormap gray
for z=1:300
    hdinterlacer = vision.Deinterlacer('Method','Line repetition'); % 'Line repetition' (default) | 'Linear interpolation' | 'Vertical temporal median filtering'
    image = pagetranspose(oct2(:,:,z));
    image = hdinterlacer(image);
    oct2(:,:,z) =  pagetranspose(image);
end
% for i=1:3
%     a(:,:,i,:) = medfilt3(squeeze(a(:,:,i,:)));
% end
for i=1:3
    oct2(:,:,i,:) = medfilt3(squeeze(oct2(:,:,i,:)));
end
%
options.color     = false;
options.compress  = 'no';
options.message   = true;
options.append    = false;
options.overwrite = true;
options.big       = true;

res = saveTiffStack(permute(octa(oct2),[1 2 3]),['oct.tif'], options);