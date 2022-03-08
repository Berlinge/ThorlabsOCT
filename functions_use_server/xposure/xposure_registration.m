TRaw2 = abs(TRaw);
for i=1:size(TRaw,3)
    TRaw2(:,:,i,:) = registration_b_scans(abs(TRaw(:,:,i,:)));
    i
end
%%
stdRaw = nanstd(abs(TRaw2),[],4);
stdRaw = stdRaw(:,:,1:2:end);
% stdRaw = log(stdRaw+1);
stdRaw = stdRaw-min(stdRaw(:));
stdRaw = stdRaw./max(stdRaw(:));
stdRaw = imresize3(stdRaw,[size(TRaw,1) size(TRaw,2) size(TRaw,3)]);
h=implay(permute(stdRaw,[2 3 1]));
h.Visual.ColorMap.UserRange = true;
h.Visual.ColorMap.UserRangeMax = 1;
%%
stdRaw = nanstd(abs(TRaw),[],4);
stdRaw = stdRaw(:,:,1:2:end);
% stdRaw = log(stdRaw+1);
stdRaw = stdRaw-min(stdRaw(:));
stdRaw = stdRaw./max(stdRaw(:));
stdRaw = imresize3(stdRaw,[size(TRaw,1) size(TRaw,2) size(TRaw,3)]);
%%
stdRaw = histeq(stdRaw);
h=implay(permute(stdRaw,[2 3 1]));
h.Visual.ColorMap.UserRange = true;
h.Visual.ColorMap.UserRangeMax = 1;