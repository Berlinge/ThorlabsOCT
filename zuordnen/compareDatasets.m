% Last Update: 2020-06-24
%% Reshape arrays (broken)
clearvars Set_full
for i=2:size(Set,1)
    Set{i,4} = reshape(Set{i,4},[size(Set_full,1) size(Set_full,2) size(Set_full,3)*size(Set_full,4)]);
end
%% Calc Std for each Dataset
Set{1,5} = 'Standard deviation';
for i=2:size(Set,1)
    Set{i,5} = std(abs(Set{i,3}),0,3);
end
% for rgb=1:3
%     d = log(s(:,:,rgb,:)+1);
%     d = d-min(d(:));
%     d = d./max(d(:));
%     s(:,:,rgb,:) = d;
% end
%% Calc dOCT for each Dataset (without scaling [0 1])
Set{1,5} = 'dOCT';
for i=2:size(Set,1)
    Set{i,6} = dOCT_fun(abs(Set{i,4}),0);
end
%% Registration for each Dataset
Set{1,6} = 'Registration';
for i=2:size(Set,1)
    Set{i,7} = registration_b_scans(Set{i,4});
end

%% Extract Data into one array
clearvars s; clc; k = 1;
spalte = 5; % which column
for i=2:size(Set,1)
    if isempty(Set{i,spalte})~= 1
        s(:,:,k) = Set{i,spalte};
        k = k+1;
    end
end

%% Implay function
h = implay(octa(s_full));
h.Visual.ColorMap.UserRange = true;
h.Visual.ColorMap.UserRangeMax = 100;

%% Save datastack into tiff / write into user given directory
options.color     = true;
options.compress  = 'no';
options.message   = true;
options.append    = false;
options.overwrite = true;
options.big       = true;
outputpath = uigetdir;
res = saveTiffStack(permute(output(:,:,:,:),[1 2 3 4]),[outputpath,'\output.tif'], options);