clearvars ROI_save indlist
% find Focus 
xx = 75;
for i=2:size(Set,1)
    Raw = Set{i,4};
    [~,ind] = max(movmean(mean(octa(Raw(:,:,1)),2),10),[],1);
    indlist(i-1) = ind;
end

% ROI select
indlist = round(movmean(indlist,3));
for i=2:size(Set,1)
    Raw = Set{i,4};
    ROI = Raw(indlist(i-1)-xx:indlist(i-1)+xx,250-xx:250+xx,:);
    ROI_s = std(ROI,0,3);
    ROI_s= repmat(ROI_s,[1 1 150]);
    ROI(log(ROI_s)<15) = NaN;
    ROI = squeeze(nanmean(nanmean(ROI,1),2));
    ROI = fftshift(fft(log(ROI)));
    ROI_save{i-1,1} = indlist(i-1);
    ROI_save{i-1,2} = squeeze((abs(ROI(76:end))));
    ROI_save{i-1,3} = Set{i,1};
    i
end

% visualize
clearvars ind
for i=1:size(ROI_save,1)
    ind(i) = ROI_save{i,1};
    signal = log(ROI_save{i,2});
    signal_map(:,i) = signal;
    %     signal = movmean(signal,3);
    plot(signal)
    timestamp = ROI_save{i,3};
    timestamp = timestamp(25:end-15);
    timestamp = insertAfter(timestamp,2,"-");
    timestamp = insertAfter(timestamp,5,"-");
    title(timestamp)
    xlim([0 75])
    ylim([-5 20])
    pause(0.01)
end

%% Evaluate signal frequency map
imagesc(medfilt2(abs((signal_map(6:end,:)+20)),[2 2],'symmetric'))