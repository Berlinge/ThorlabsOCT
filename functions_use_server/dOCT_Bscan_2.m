function [Raw,inf] = dOCT_Bscan(path,file,function_name)
% Fast dOCT mode: Calculate dynamic contrast on absolute values
% Support: Registration
% Last Update: 2020-06-10
% try
    [Raw,inf,function_name] = load_to_memory(path,file,function_name); % PRaw is only pointer to mat-File
    clc;
    %%
    Raw = Raw(1:1024,:,:);
    Z = size(Raw,1);X = size(Raw,2);T = size(Raw,3);
    
    if inf.postprocessing.image_registration == 1
        [Raw] = registration_b_scans(Raw);
    end
    r =1;g=2;b=3;
      % 3D(Z,X,T) zu  2D(ZX,T) 
    DataArray_hlp= reshape((Raw(:,:,1:T)),[Z*X,T]);
    
    % Fourier Transformation der Zeitserie
    DataArray_freq = abs(fft(DataArray_hlp,[],2));

    image(:,:,r)  = sum(DataArray_freq(:,8:36),2);
    image(:,:,g)  = sum(DataArray_freq(:,2:7),2);
    image(:,:,b)  = sum(DataArray_freq(:,1),2); 
    
    % Logarithmieren der einzelnen Farbkanäle
    image(:,:,r) = log(image(:,:,r))+1;
    image(:,:,g) = log(image(:,:,g))+1;
    image(:,:,b) = log(image(:,:,b))+1;
    
    % Normieren der einzelnen Farbkanäle 
    image(:,:,r) = image(:,:,r) - min(image(:,:,r),[],'all');
    image(:,:,r) = image(:,:,r) / max(image(:,:,r),[],'all');
    image(:,:,g) = image(:,:,g) - min(image(:,:,g),[],'all');
    image(:,:,g) = image(:,:,g) / max(image(:,:,g),[],'all');
    image(:,:,b) = image(:,:,b) - min(image(:,:,b),[],'all');
    image(:,:,b) = image(:,:,b) / max(image(:,:,b),[],'all');
%     
    % 2D(ZX,T) zu  3D(Z,X,T) 
    image= reshape(image,[Z,X,3]);
   
%%%% Histogram adjustment to STD-Image
    % Berechnung der STD (Algorithmus Micha)
    DataArray_std = pca(DataArray_hlp');
    DataArray_std = std(DataArray_std(:,2:end),0,2);
    % Logarithmieren
    DataArray_std = log(DataArray_std);
    % Normieren
    DataArray_std = DataArray_std - min(DataArray_std,[],'all');
    DataArray_std = DataArray_std / max(DataArray_std,[],'all');
    % Histogram adjustment
    image = imhistmatch(image,DataArray_std);
    
    %%%% Denoise 
    image(:,:,1) = medfilt2(image(:,:,1));
    image(:,:,2) = medfilt2(image(:,:,2));
    image(:,:,3) = medfilt2(image(:,:,3));    
    
    % Background substruction
    radius = 250;
    h = 1;
    SE = offsetstrel('ball',radius,h);
    c  = imtophat(image,SE);
    
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
% catch
% end
%% Extend
end