%% exp- set nan
Raw(:,3001:3003,:) = NaN;
%
%% evaluate 
k = 2;
imagesc(octa(Raw(:,:,k)))
%% Cut for better memory usage
Raw = Raw(1:300,:,:);
%% Reshape volume
clearvars test
imagei = 1;
for xxx=1
% TRaw = Raw;
% TRaw(:,xxx:3003,:) = circshift(Raw(:,3003,:),3,2);
TRaw  = reshape(TRaw,size(TRaw,1),size(TRaw,2)*size(TRaw,3));
% 391 ist der Abstand von NaN zu echter bestimmen Stelle 
try
    for i=3001:3003:size(TRaw,2)
        TRaw(:,i:i+xxx) = circshift(TRaw(:,i:i+xxx),-3,2); 
    end
catch
end
x_steps = inf.id1{3,2};
y_steps = inf.id1{7,2};
scan_stitch = inf.id1{10,2};
stitch_repeat = inf.id1{11,2};
begin_position = 2061+(k-1)*3000;
end_position = begin_position+x_steps*y_steps*scan_stitch*stitch_repeat;
TRaw = TRaw(:,begin_position:end_position-1);
TRaw  = reshape(TRaw,[size(TRaw,1) x_steps size(TRaw,2)/x_steps]); %% reshape back
if strcmp(inf.id2{1,1},'bidirektional') % flip for bidirectional
    for i=1:2:size(TRaw,3)
        TRaw(:,:,i) = fliplr(TRaw(:,:,i));
    end
end
% shape back to volumes / timesReset dims
TRaw = reshape(TRaw,[size(TRaw,1) x_steps y_steps stitch_repeat*(scan_stitch)]); % minus 1 because of lost first one
TRaw = reshape(TRaw,[size(TRaw,1) x_steps y_steps stitch_repeat (scan_stitch)]); %
% Stick everything together
TRaw = permute(TRaw,[1 2 3 5 4]);
TRaw = reshape(TRaw,[size(TRaw,1),size(TRaw,2),size(TRaw,3)*size(TRaw,4),size(TRaw,5)]);

stdimage = squeeze(nanstd(squeeze(TRaw(100,:,1:1:end,:)),0,3)); 
stdimage = log(stdimage+1);
stdimage = stdimage-min(stdimage(:));
stdimage = stdimage./max(stdimage(:));
test(:,:,imagei) = stdimage;
imagei = imagei+1;
pause(0.01)
end
% h = implay(octa(TRaw(:,:,2:2:end,:)))
% h.Visual.ColorMap.UserRange = true;
% h.Visual.ColorMap.UserRangeMax = 100;
% Go through t for one B_Scan
h=implay(octa(TRaw(:,:,188,:)));
h.Visual.ColorMap.UserRange = true;
h.Visual.ColorMap.UserRangeMax = 100;
%% Go through dynamic Volume
stdRaw = nanstd(abs(TRaw),0,4);
stdRaw = stdRaw(:,:,1:2:end);
stdRaw = log(stdRaw+1);
stdRaw = stdRaw-min(stdRaw(:));
stdRaw = stdRaw./max(stdRaw(:));
% stdRaw = imresize3(stdRaw,[size(TRaw,1) size(TRaw,2) size(TRaw,3)]);
% stdRaw = medfilt3(stdRaw);
h=implay(permute(stdRaw,[2 3 1]));
h.Visual.ColorMap.UserRange = true;
h.Visual.ColorMap.UserRangeMax = 1;
%%  Save std stack
options.color     = false;
options.compress  = 'no';
options.message   = true;
options.append    = false;
options.overwrite = true;
options.big       = true;
path = fullfile(inf.path,inf.file{1,inf.i});
res = saveTiffStack(permute(stdRaw(:,:,:),[1 2 3]),[path(1:end-4),'\std.tif'], options);