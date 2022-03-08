% ROI = angle(Raw(1:1024,:,:));
ROI = log(abs(Raw(1:1024,:,:)));

ROI_w = [251 49 1 499];
imagesc(std(ROI,0,3))
colormap gray
rectangle('Position',[ROI_w(3) ROI_w(1) ROI_w(4) ROI_w(2)])
ROI = ROI(ROI_w(1):ROI_w(1)+ROI_w(2),ROI_w(3):ROI_w(3)+ROI_w(4),:);
erg = squeeze(mean(mean(std(diff(ROI,2,3),0,3),1),2))