function [Raw,inf] = dOCT_SpeckeVariance(path,file,function_name)
% Fast dOCT mode
% Calculate dynamic contrast on absolute values
try
[Raw,inf,function_name] = load_to_memory(path,file,function_name); % PRaw is only pointer to mat-File
clc;
%%
% if length(size(Raw))~=4
%     disp('Seems like its not SV volume')
%     return
% end
Raw = reshape(Raw,[inf.SizeZ inf.SizeX inf.SaSA inf.SizeY]);
%Raw = squeeze(std(Raw,0,3));

output = zeros(1024,size(Raw,2),size(Raw,4),3,'single');
for i=1:inf.SizeY
    output(:,:,i,:) = dOCT(Raw(1:1024,:,:,i),0); % second input is Version
end

try % prepare save in location
    %mkdir(fullfile(userdir,'Desktop\Auswertung\'))
    mkdir(fullfile(path,['\Auswertung_',function_name]))
catch
end

%% Check for image field correction
if inf.postprocessing.image_field_correction == 1
    output = segmentation_gui(output);
end
%% write into directory
options.color     = true;
options.compress  = 'no';
options.message   = true;
options.append    = false;
options.overwrite = true;
options.big       = true;

outputpath = fullfile(path,['\Auswertung_',function_name],strcat(convertStringsToChars(inf.Comment),'_',convertStringsToChars(inf.file{1,inf.i})));

res = saveTiffStack(permute(output(:,:,:,:),[1 2 4 3]),[outputpath,'_rgb.tif'], options);
catch
    
end
end