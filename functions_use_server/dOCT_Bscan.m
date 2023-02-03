function [Raw,inf] = dOCT_Bscan(path,file,function_name)
% Fast dOCT mode: Calculate dynamic contrast on absolute values
% Support: Registration
% Last Update: 2020-06-10
try
    [Raw,inf,function_name] = load_to_memory(path,file,function_name); % PRaw is only pointer to mat-File
    clc;
    %%
    if inf.postprocessing.image_registration == 1
        [Raw] = registration_b_scans(Raw);
    end
    c = dOCT(Raw(1:1024,:,:),0);
    
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
    %imwrite(c,fullfile(path,['\Auswertung_',function_name],strcat(convertStringsToChars(inf.Comment),'_',convertStringsToChars(inf.file{1,inf.i}),'_rgb.png')));
    % write to desktop
    %imwrite(c,fullfile(userdir,'Desktop\Auswertung\',strcat(convertStringsToChars(inf.Comment),'_',convertStringsToChars(inf.file{1,inf.i}),'_rgb.png')));
    
    %just for dissertation
    prompt = 'Size of window';
    x = input(prompt)
    imwrite(c,fullfile(path,['\Auswertung_',function_name],[num2str(x),'_rgb.png']));
    imwrite(uint8(20.*log10(squeeze(mean(Raw,3)))),fullfile(path,['\Auswertung_',function_name],[num2str(x),'_mean.png']));

catch
end
%% Extend
end