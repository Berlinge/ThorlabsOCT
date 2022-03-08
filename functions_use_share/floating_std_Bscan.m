function [Raw,inf] = floating_std_Bscan(path,file,function_name)
% Calculate standard deviation (floating - 150Bscans) on absolute values
% Support: Registration
% Last Update: 2020-06-22
try
    [Raw,inf,function_name] = load_to_memory(path,file,function_name); % PRaw is only pointer to mat-File
    clc;
    %%
    Raw_backup = Raw;
    k = 1;
    for i=1:size(Raw_backup,3)-149
        Raw = Raw_backup(:,:,i:i+149);
        if inf.postprocessing.image_registration == 2
            [Raw] = registration_b_scans(Raw);
        end
        std_help = std(Raw(1:1024,:,:),0,3);
        std_stack(:,:,k) = std_help;
        k = k+1;
    end
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
    save(fullfile(path,['\Auswertung_',function_name],[convertStringsToChars(inf.file{1,inf.i}),'std_stack.mat']),'std_stack','-v7.3','-nocompression');
    saveTiffStack(abs(std_stack),fullfile(path,['\Auswertung_',function_name],[convertStringsToChars(inf.file{1,inf.i}),'_std_abs.tiff']));
    saveTiffStack(octa(std_stack),fullfile(path,['\Auswertung_',function_name],[convertStringsToChars(inf.file{1,inf.i}),'_std_octa.tiff']));
    
    catch
end
%% Extend
end