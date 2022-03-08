function [] = save_tiff(path,file,function_name)
% saves OCT-data as tiff file
% supports: Image registration and Image segmentation (GUI)
[Raw,inf] = load_to_memory(path,file,function_name);
%%%
if length(inf.SizeZ)>1
    inf.SizeZ = inf.SizeZ(2)-inf.SizeZ(1)+1;
end
%%%
% imagesc(octa(PRaw.Raw(300:800,:,1)))

%% Check for image registration
if inf.postprocessing.image_registration == 1
    Raw = registration_b_scans(Raw);
end
%% Check for image field correction
if inf.postprocessing.image_field_correction == 1
    Raw = segmentation_gui(Raw);
end
Raw = Raw-min(Raw(:))+1;
Raw = Raw./max(Raw(:));
options.color     = false;
options.compress  = 'no';
options.message   = true;
options.append    = false;
options.overwrite = true;
options.big       = true;
try
    mkdir(fullfile(path,file(1:end-8),function_name))
catch
end
try
    saveTiffStack(abs(Raw),fullfile(path,file(1:end-8),char(function_name),'abs.tiff'), options);
    saveTiffStack(octa(Raw),fullfile(path,file(1:end-8),char(function_name),'octa.tiff'), options);
    disp('saveTiffStack finished')
catch
    disp('saveTiffStack failed')
end
end