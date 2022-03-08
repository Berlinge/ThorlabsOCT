function [] = display_data(image)
image = squeeze(image);
n = 1.3;
image = imresize(image,[round(size(image,1)*(820/1024)) size(image,2)]); % resize to original dimension
image = imresize(image,[round(size(image,1)/n) size(image,2)]); % resize to optical path length of sample
% image = image-min(image(:));
% image = image./max(image(:));
try
    close(figure(3)) 
catch
end
fig3 = figure(3);
fig3.Position = [fig3.Position(1) fig3.Position(2) round(fig3.Position(3)*0.6) round(fig3.Position(4)*0.7)];
clf(3)
set(gcf,'color','w');

imagesc(image)
if length(size(image)) == 2
    colormap gray
end
axis equal tight; 
hold on
set(gca,'xticklabel',{[]})
set(gca,'yticklabel',{[]})
xlabel('x')
ylabel('z')
h = colorbar;
caxis([min(image(:)) 0.3])
ylabel(h, ' ')
scalec = 'w';
scalebar

ax()
print(fig3,'-dmeta')
end

function [] =  ax()
set(gca,'FontSize',8,'FontName','Arial')
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName','Arial')
end

