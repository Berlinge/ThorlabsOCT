hold on
zm = round(0.95*size(image,1));
xm = round(0.9*size(image,2))-100;

plot([xm,xm+100],[zm,zm],'Color',scalec,'LineWidth',5);
white = [1 1 1];
black  = [0 0 0];
% text(xm+25,zm+20,'100 µm','Color',white,'FontSize',8)