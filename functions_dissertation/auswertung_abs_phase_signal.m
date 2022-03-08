clc;
clearvars -except Raw inf Raw_n Raw_n2
fig = figure(1);
Raw_n = Raw;
clf(1)
% fig.Position = [fig.Position(1) fig.Position(2) 560 500];
set(gcf,'color','w');
z1 = 1;
z2 = 1024;
z  = 433;
zz = 16;
x  = 223;
xx = 7;

image_abs = abs(Raw_n(z1:z2,:,:));
image_phase = angle(Raw_n(z1:z2,:,:));
signal_abs = squeeze(mean(mean(image_abs(z:z+zz,x:x+xx,:),1),2));
signal_phase = squeeze(mean(mean(image_phase(z:z+zz,x:x+xx,:),1),2));

intensity_mean_octa = mean(octa(Raw(1:1024,:,:)),3);
intensity_max_octa = max(octa(Raw(1:1024,:,:)),[],3);
intensity_std_octa = std(octa(Raw(1:1024,:,:)),0,3);
intensity_mean_abs = mean(abs(Raw(1:1024,:,:)),3);
intensity_max_abs = max(abs(Raw(1:1024,:,:)),[],3);
intensity_std_abs = std(abs(Raw(1:1024,:,:)),0,3);

%% imagesc std intensity image and std phase image
subplot(1,2,1)
imagesc(std(image_abs,0,3))
axis equal tight; hold on
rectangle('Position',[x z xx zz],'EdgeColor','r','LineWidth',1)
title('abs');
annotation('textbox', [0.25, 0.15, 0, 0], 'string', 'a)');
set(gca,'xticklabel',{[]})
set(gca,'yticklabel',{[]})
xlabel('x')
ylabel('z')
h = colorbar;
ylabel(h, 'dB')

subplot(1,2,2)
imagesc((std(unwrap(image_phase,[],3),0,3)))
axis equal tight
hold on
rectangle('Position',[x z xx zz],'EdgeColor','r','LineWidth',1)
title('phase');
annotation('textbox', [0.75, 0.15, 0, 0], 'string', 'b)');
set(gca,'xticklabel',{[]})
set(gca,'yticklabel',{[]})
xlabel('x')
ylabel('z')
caxis([0 5])
h = colorbar;
ylabel(h, 'rad')

ax()
print(fig,'-dmeta')

%% imagesc roi intensity image and roi phase image
fig2 = figure(2);
clf(2)
set(gcf,'color','w');

subplot(1,2,1)
plot(signal_abs)
title('abs');
annotation('textbox', [0.25, 0.05, 0, 0], 'string', 'c)');
xlabel('t')
ylabel('dB')
subplot(1,2,2)
plot(unwrap(signal_phase,[],3))
title('phase'); annotation('textbox', [0.75, 0.05, 0, 0], 'string', 'd)');
xlabel('t')
ylabel('rad')

ax()
print(fig2,'-dmeta')
%%% imagesc roi intensity image and roi phase image

%% imagesc normal octa image and intensity image
close all
image = log(intensity_std_abs+1);
% image = dOCT(Raw(1:1024,:,:),0);
% image = log(std(image_abs,0,3)+1);
% image = intensity_mean_octa;
% image = log(test_image+1);
% image = image-min(image(:));
% image = image./max(image);
n = 1.3;
image = imresize(image,[round(size(image,1)*(820/1024)) size(image,2)]);
image = imresize(image,[round(size(image,1)/n) size(image,2)]);
fig3 = figure(3);
fig3.Position = [fig3.Position(1) fig3.Position(2) round(fig3.Position(3)*0.6) round(fig3.Position(4)*0.7)];
clf(3)
set(gcf,'color','w');
imagesc(image)
colormap gray
axis equal tight; hold on
set(gca,'xticklabel',{[]})
set(gca,'yticklabel',{[]})
xlabel('x')
ylabel('z')
h = colorbar;
caxis([min(image(:)) max(image(:))])
ylabel(h, 'log(Int)')
scalec = 'w';
scalebar

ax()
print(fig3,'-dmeta')

%%
function [] =  ax()
set(gca,'FontSize',8,'FontName','Arial')
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName','Arial')
end