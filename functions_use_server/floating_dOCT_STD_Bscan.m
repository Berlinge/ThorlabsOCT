function [Raw,inf] = floating_dOCT_STD_Bscan(path,file,function_name)
% Fast dOCT mode: Calculate Standard Deviation on absolute values
% Support: Registration
% Last Update: 2020-06-24 (Tabea)
try
    [Raw,inf,function_name] = load_to_memory(path,file,function_name); % PRaw is only pointer to mat-File
    clc;
    %%
    Raw_backup = abs(Raw);
    k = 1;
    for i=1:size(Raw_backup,3)-149
        Raw = Raw_backup(:,:,i:i+149);
        if inf.postprocessing.image_registration == 1
            [Raw] = registration_b_scans(Raw);
        end
        %c =  dOCT(Raw(1:1024,:,:),0);
        c = dOCT(Raw(1:1024,:,:),1);
        c_a(:,:,:,k) = c;
        k = k+1;
    end
    %%
    if ispc
        userdir = getenv('USERPROFILE');
    else
        userdir = getenv('HOME');
    end
    
    try
        mkdir(fullfile(path,['\Auswertung_',function_name]))
    catch
    end
    % write into directory
    save(fullfile(path,['\Auswertung_',function_name],[convertStringsToChars(inf.file{1,inf.i}),'_c_a.mat']),'c_a','-v7.3','-nocompression');
    %     imwrite(c_a,fullfile(path,['\Auswertung_',function_name],strcat(convertStringsToChars(inf.Comment),'_',convertStringsToChars(inf.file{1,inf.i}),'_rgb.png')));
    % write to desktop
    %imwrite(c,fullfile(userdir,'Desktop\Auswertung\',strcat(convertStringsToChars(inf.Comment),'_',convertStringsToChars(inf.file{1,inf.i}),'_rgb.png')));
catch
end
%% Extend
end