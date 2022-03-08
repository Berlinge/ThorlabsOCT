sr = registration_b_scans_floating(s);
%%
implay(sr)
%%
clc
for i=1:39
    ROI = sr(71:130,476:535,i);
    signal(i) = mean(mean(ROI,1),2);
    contrast(i) = max(ROI(:))-min(ROI(:));
end
fig = figure(2);
clf(2)
% boxplot(reshape(signal,[3 13]))
% plot(contrast)
hold on
boxplot(reshape(contrast,[3 13]),'Color','k')

print(fig,'-dmeta')