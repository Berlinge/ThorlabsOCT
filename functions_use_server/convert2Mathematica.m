function [] = convert2Mathematica(path,file,function_name)
% Converts OCT files into Mathematica Files
% Last update: 01.04.2020
clc;
[Raw,inf,function_name] = load_to_memory(path,file,function_name); % PRaw is only pointer to mat-File
if length(inf.SizeZ)>1
    inf.Sizpath = 'Z:\2020-01-09\';
end

try
    mkdir(fullfile(path,file(1:end-8),function_name))
catch
end

for i=1:size(Raw,3)
    %    image_real = double(real(RawB(:,:,i)));
    %    image_imag = double(imag(RawB(:,:,i)));
    image = double(Raw(:,:,i));
    
    save(fullfile(path,file(1:end-8),function_name,[num2str(i),'.mat']),'image','-v4');
    
    %    saveTiffStack(permute(Channel(:,:,:,i),[3 2 1]R),fullfile(path,file(1:end-8),function_name,C{1,i}), options);
    
end