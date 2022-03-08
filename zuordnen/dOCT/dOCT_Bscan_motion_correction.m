function [Raw,inf] = dOCT_Bscan_motion_correction(path,file,function_name)
% Fast dOCT mode
% Calculate dynamic contrast on absolute values
try
[Raw,inf,function_name] = load_to_memory(path,file,function_name); % PRaw is only pointer to mat-File
clc;
%%
if inf.postprocessing.image_registration == 1
    Raw = registration_b_scans(Raw);
end
%%
% Raw = movstd(Raw,10,0,3);
%%
TRaw = pca(reshape(permute(abs(Raw),[3 1 2]),[size(Raw,3) size(Raw,1)*size(Raw,2)]));
TRaw = reshape(TRaw(:,:,:),[size(Raw,1) size(Raw,2) size(Raw,3)-1]);
c = std(TRaw(:,:,2:end),0,3);
% c = mean(Raw,3);
c = medfilt2(c);
c = c-min(c(:));
c = c./max(c(:));
%%
if ispc
    userdir = getenv('USERPROFILE');
else
    userdir = getenv('HOME');
end
try
    %mkdir(fullfile(userdir,'Desktop\Auswertung\'))
    mkdir(fullfile(path,['\Auswertung_',function_name]))
catch
end

% write into directory
imwrite(c,fullfile(path,['\Auswertung_',function_name],strcat(convertStringsToChars(inf.Comment),'_',convertStringsToChars(inf.file{1,inf.i}),'_rgb.png')));
% write to desktop
%imwrite(c,fullfile(userdir,'Desktop\Auswertung\',strcat(convertStringsToChars(inf.Comment),'_',convertStringsToChars(inf.file{1,inf.i}),'_rgb.png')));
catch
end
%% Extend
end