for ss=2:size(Set,1)
    Raw_backup = Set{ss,4}(251:600,:,:);
    k = 1;
    clearvars c_a
    for i=1:50:size(Raw_backup,3)-149-100
        Raw = Raw_backup(:,:,i:i+149);
        c_a(:,:,:,k) = dOCT_fun(Raw(:,:,:),0);
%         c_b(:,:,:,k) = dOCT(Raw(:,:,:),0);
%         c_c(:,:,:,k) = std(Raw(:,:,:),0,3);
        k = k+1;
    end
    Set{ss,5} = c_a;
%     Set{ss,6} = c_b;
%     Set{ss,7} = c_c;
    ss
end
%%
clearvars s
for i=2:size(Set,1)
    s(:,:,:,:,i-1) = Set{i,5}-min(Set{i,5}(:));
end
s = reshape(s,[size(s,1) size(s,2) size(s,3) size(s,4)*size(s,5)]);
%%
for rgb=1:3
%     d = log(s(:,:,rgb,:)+1);
    d = s(:,:,rgb,:);
%     d = d-min(d(:));
    d = d./max(d(:));
    s(:,:,rgb,:) = d;
end
%%
implay(s)
%%
ROI = [101 200 1 500]; % x1-x2 y1-y2
figure(1);
plot(squeeze(mean(mean(squeeze(s(ROI(1):ROI(2),ROI(3):ROI(4),1,:)),1),2)),'r')
hold on
plot(squeeze(mean(mean(squeeze(s(ROI(1):ROI(2),ROI(3):ROI(4),2,:)),1),2)),'g')
hold on
plot(squeeze(mean(mean(squeeze(s(ROI(1):ROI(2),ROI(3):ROI(4),3,:)),1),2)),'b')
size(Set{2,4})