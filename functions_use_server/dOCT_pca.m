function [] = dOCT_pca(path,file,function_name)
% Principle Component Analysis / bessere Darstellung fuer dOCT
% Last update: 2020-06-29
[Raw,inf] = load_to_memory(path,file,function_name);
%%
sizeZ = 1024;
Rawt = Raw(1:sizeZ,:,:);
% Rawt = Raw(1:sizeZ,:,1:200);
clc;
test = pca(reshape(permute(abs(Rawt),[3 1 2]),[size(Rawt,3) size(Rawt,1)*size(Rawt,2)]));
% test = pca(reshape(permute(unwrap(angle(Raw_02(1:1024,:,:)),[],3),[3 1 2]),[150 1024*500]));
test_image = reshape(test(:,:,:),[size(Rawt,1) size(Rawt,2) size(Rawt,3)-1]);
test_image = std(test_image(:,:,2:end),0,3);
test_image = log(medfilt2((test_image),[3 3])+1);
test_image = test_image-min(test_image(:));
test_image = test_image./max(test_image(:));
%%
try
    mkdir(fullfile(path,['\Auswertung_',function_name]))
catch
end
% write into directory
imwrite(test_image,fullfile(path,['\Auswertung_',function_name],strcat(convertStringsToChars(inf.Comment),'_',convertStringsToChars(inf.file{1,inf.i}),'_pca.png')));
end