clc;
load('E:\OneDrive\Dissertation\Daten\enface.mat');
load('E:\OneDrive\Dissertation\Daten\output.mat');

% Save enface image as uint16 rgb -> idk_snap
rgb = im2uint16(output);
figure(1); clf(1);
imagesc(rgb); axis equal tight
cmap  = colormap;
dicomwrite(rgb,'E:\OneDrive\Dissertation\Daten\enface.dcm')
pause(0.5);

cmap = [1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 1 0]; % Colormap

% Read labels from idf_snap from nifti-file
clearvars -except output enface cmap
% Read segmented data binary
clearvars BW; clc;
V = niftiread('E:\OneDrive\Dissertation\Daten\segmentation_enface.nii.gz')';
labels = unique(V); labels(labels==0) = [];
for i=1:length(labels)
    bw = V; bw(bw~=labels(i)) = 0; bw = logical(bw); %bw(bw==labels(i)) = 1;
    BW(:,:,i) = bw;
    bwi = double(bw);
    [indi] = find(bw(:,:,1)==1);
    ind{i} = indi;
end
clearvars bw indi

% Auswertung der labels
clc; clearvars lp lp_h
for i=1:size(BW,3)
    for t=1:size(enface,3)
        enface_t = enface(:,:,t);
        lp_h(:,t) = enface_t(BW(:,:,i));
    end
    lp{2,i} = lp_h;
    clearvars lp_h
end
clearvars i t

% FFT der gemittelten Labels
for i=1:size(BW,3)
    lp{3,i} = log(abs(fftshift(fft(lp{2,i},100,2),2)));
    lp{3,i} = mean(lp{3,i},1);
%     lp{3,i} = lp{3,i}./max(lp{3,i}(:));
    lp{10,i} = (abs(fft(lp{2,i},100,2)));
end

% Darstellung der FFT der gemittelten Labels
figure(2),clf(2);
for i=1:size(BW,3)
    plot(lp{3,i},'Color',cmap(i,:))
    hold on
end
hold off
axis tight
legend('Label 1','Label 2','Label 3','Label 4')
% plot(squeeze(mean(log(abs(ftest)),1))./squeeze(mean(log(abs(ftest2)),1)))

%
figure(3); clf(3); clc;
clearvars rgb
for i=1:size(BW,3)
    input = fft(enface,100,3);% extract from orig image
    input = input(1:size(input,1),:,:);
    b_o = sum(abs(input(:,:,1:1)),3);
    g_o = sum(abs(input(:,:,2:8)),3);
    r_o = sum(abs(input(:,:,9:36)),3);
    
    input = lp{10,i};
    b = sum(abs(input(:,1:1)),2);
    g = sum(abs(input(:,2:8)),2);
    r = sum(abs(input(:,9:36)),2);
    
    r = log(r./max(r_o(:)));
    g = log(g./max(g_o(:)));
    b = log(b./max(b_o(:)));
    r_o = log(r_o./max(r_o(:)));
    g_o = log(g_o./max(g_o(:)));
    b_o = log(b_o./max(b_o(:)));
    
    r_o = medfilt2(r_o);
    g_o = medfilt2(g_o);
    b_o = medfilt2(b_o);
    
    r = r-min(r_o(:));
    g = g-min(g_o(:));
    b = b-min(b_o(:));
    r_o = r_o-min(r_o(:));
    g_o = g_o-min(g_o(:));
    b_o = b_o-min(b_o(:));
    
    r = r./max(r_o(:));
    g = g./max(g_o(:));
    b = b./max(b_o(:));
    r_o = r_o./max(r_o(:));
    g_o = g_o./max(g_o(:));
    b_o = b_o./max(b_o(:));
    
    output = cat(3,r_o,g_o,b_o);
    
    % Display label as overlay with image
    cmap = [1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 1 0]; % Colormap
    image = labeloverlay(output,V,'Colormap',cmap);
    figure(1); clf(1)
    imagesc(image)
    axis equal tight
    clearvars image
    
    rgb(:,i) = [mean(r,1) mean(g,1) mean(b,1)];
    r = mean(r,1).*ones(100,100);
    g = mean(g,1).*ones(100,100);
    b = mean(b,1).*ones(100,100);
    figure(3), clf(3)
    imagesc(cat(3,r,g,b));
    
    pause(0.2)
end
test = bar(rgb','stacked');
test(1,1).FaceColor = [1 0 0];
test(1,2).FaceColor = [0 1 0];
test(1,3).FaceColor = [0 0 1];
ylim([0 3])
% clc;
% for i=1:4
%     test(:,i) = rgb(:,i)/norm(rgb(:,i),1);
% end
% testb = bar(test','stacked');
% testb(1,1).FaceColor = [1 0 0];
% testb(1,2).FaceColor = [0 1 0];
% testb(1,3).FaceColor = [0 0 1];
% ylim([0 3])

%% Recreate original image with segmentation
test = zeros(500,550,3);
rtest = test(:,:,1);
gtest = test(:,:,2);
btest = test(:,:,3);
for i=1:4
    rtest(ind{i}) = rgb(1,i);
    gtest(ind{i}) = rgb(2,i);
    btest(ind{i}) = rgb(3,i);
end
test = cat(3,rtest,gtest,btest);
f5 = figure('Name','Recreate Data from segmentation');
imagesc(test);
%% Verhältnisse darstellen zwischen RGB
label = 4;
rgb(1,label)/rgb(2,label)
rgb(2,label)/rgb(3,label)
rgb(1,label)/rgb(3,label)
figure(3)
p = pie(double(rgb(:,label)))
p(1,1).FaceColor = [1 0 0];
p(1,3).FaceColor = [0 1 0];
p(1,5).FaceColor = [0 0 1];
%% Restore pixels 
clc;
test = zeros(500,550,100);
for i=1:4
    for t=1:100
        e = test(:,:,t);
        e(ind{1,i}) = lp{2,i}(:,t);
        test(:,:,t) = e;
    end
end
input = fftshift(fft(test,100,3),3);
testb = sum(abs(input(:,:,1:1)),3);
testg = sum(abs(input(:,:,2:8)),3);
testr = sum(abs(input(:,:,9:36)),3);
r = log(r./max(r(:))+1);
g = log(g./max(g(:))+1);
b = log(b./max(b(:))+1);
r = medfilt2(r);
g = medfilt2(g);
b = medfilt2(b);
r = r-min(r(:));
g = g-min(g(:));
b = b-min(b(:));
r = r./max(r(:));
g = g./max(g(:));
b = b./max(b(:));
output = cat(3,r,g,b);   
%% testumgebung
clc; clearvars cout c;
for label=1:4
    for i=1:3
        test = output(:,:,i).*double(BW(:,:,label));
        ebene = output(:,:,i);
        c = mean(mean(ebene(BW(:,:,label)),1),2);
        out(:,:,i) = test;
        %     cout(:,:,i) = c.*ones(100,100);
        cout(:,:,i) = c;
    end
    figure(1), clf(1)
    imagesc(out)
    figure(2), clf(2)
    imagesc(cout)
    pause(1)
end