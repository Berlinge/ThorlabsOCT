function [] = preview_manipulate(path,file,function_name) % PRaw is only pointer to mat-File
% Crop images
clc;
file = fullfile(path,file);
load(file,'inf');
if strcmp(inf.path,path)~=1 % check if files were stored at any other location
    inf.path = path;
end
try
    j = 1;
    m = matfile(fullfile(file(1:end-8),[num2str(j),'.mat']));
    hf = figure;
    imagesc(octa(m.b_scan))
    colormap gray
    % Ask user for two numbers.
    try
        try
            SizeZ(1) = inf.SizeZ(1);
            SizeZ(2) = inf.SizeZ(2);
        catch
            SizeZ(1) = 1;
            SizeZ(2) = inf.SizeZ;
        end
        defaultValue = {num2str(SizeZ(1)), num2str(SizeZ(2))};
        titleBar = 'Change inf.SizeZ for postprocessing';
        userPrompt = {'Top crop: ', 'Till bottom crop '};
        UserInput = inputdlg(userPrompt, titleBar, 1, defaultValue);
        usersValue1 = uint32(str2double(UserInput{1}));
        usersValue2 = uint32(str2double(UserInput{2}));
        inf.SizeZ(1) = usersValue1;
        inf.SizeZ(2) = usersValue2;
    catch
        disp('Input numbers were wrong, repeat')
    end
    close(hf);
catch
    disp('No Raw.mat file found')
end
save(fullfile(inf.path,[inf.file{inf.i}(1:end-4),'_inf.mat']),'inf');
%% overwrite mat raw files?
end