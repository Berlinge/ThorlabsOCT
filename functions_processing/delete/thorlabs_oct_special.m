function [inf,raw] = thorlabs_oct_special(inf)
%% Intended use:
clc; clearvars -except inf
inf.disp = [20.3716,14.0767,13.7225,-72.0983,33.5304];
%profile on
tic
try
    fclose(fileID);
catch
end
try
    fileID = fopen(fullfile(inf.path,string(inf.file{inf.i})),'r');
catch
    fileID = fopen(fullfile(inf.path,inf.file{1,1}),'r');
end
%%%% read zip file
File_name = 'Start';
spectrometer ='Thorlabs';
i = 1;
fseek(fileID,0,'bof');
% profile on
% tic
while contains(File_name,"Header.xml")~=1
    %fseek(fileID,4,'cof');    %Local_file_inf.Header = typecast(fread(fileID,4,'uint8=>uint8'),'uint32');
    %fseek(fileID,2,'cof');    %Version_needed = typecast(fread(fileID,2,'uint8=>uint8'),'uint16');
    %fseek(fileID,2,'cof');    %Gpbf = typecast(fread(fileID,2,'uint8=>uint8'),'uint16');
    %fseek(fileID,2,'cof');    %Compression_method = typecast(fread(fileID,2,'uint8=>uint8'),'uint16');
    %fseek(fileID,2,'cof');    %Flmt = typecast(fread(fileID,2,'uint8=>uint8'),'uint16');
    %fseek(fileID,2,'cof');    %Flmd = typecast(fread(fileID,2,'uint8=>uint8'),'uint16');
    %fseek(fileID,4,'cof');    %CRC32 = typecast(fread(fileID,4,'uint8=>uint8'),'uint32');
    fseek(fileID,18,'cof');
    %Cs = typecast(fread(fileID,4,'uint8=>uint8'),'uint32');
    Cs = fread(fileID,1,'uint32');
    fseek(fileID,4,'cof');    %Us = typecast(fread(fileID,4,'uint8=>uint8'),'uint32');
    Fnl = typecast(fread(fileID,2,'uint8=>uint8'),'uint16');
    Efl = typecast(fread(fileID,2,'uint8=>uint8'),'uint16');
    File_name = string(fread(fileID,Fnl,'*char')'); % read File Name
    fseek(fileID,Efl,'cof');    %index = find(contains(raw(:,1),File_name));
    pointer = ftell(fileID);
    List{i,1} = string(File_name');
    List{i,2} = pointer; % offset
    List{i,3} = Cs;
    fseek(fileID, Cs,'cof');
    i = i+1;
end
% toc
% profile viewer

%%% extract special important parts
index = contains(string(List(:,1)),"Chirp"); % Extract Chirp
fseek(fileID,List{index,2},'bof');
Chirp = (typecast(fread(fileID,List{index,3},'uint8=>uint8'),'single'));

index = contains(string(List(:,1)),"Offset"); % Extract Offset
fseek(fileID,List{index,2},'bof');
Offset = single((typecast(fread(fileID,List{index,3},'uint8=>uint8'),'single')));

index = contains(string(List(:,1)),"Probe"); % Extract Probe
fseek(fileID,List{index,2},'bof');
inf.Probe = convertCharsToStrings(fread(fileID,List{index,3},'*char'));

index = contains(string(List(:,1)),"Header"); % Extract Header
fseek(fileID,List{index,2},'bof');
inf.Header = convertCharsToStrings(fread(fileID,List{index,3},'*char'));

% Sort used Dispersion and preallocate some stuff
try % Set dispersion
    if strcmp(inf.disp,'off')
        Dispersion_index = strfind(inf.Probe,'Dispersion');
        Dispersion_hlp = extractAfter(inf.Probe,Dispersion_index(1)-1);
        Dispersion_used = extractBefore(extractAfter(inf.Header,'<DispersionPreset>'),'</DispersionPreset>');
        inf.Dispersion = str2num(replace(erase(extractBefore(extractAfter(Dispersion_hlp,Dispersion_used),'Dispersion'),' ='),',',' '));
    elseif strcmp(inf.disp,'Put dispersion here')
        inf.Dispersion = inf.disp;
    else
        try
            inf.Dispersion = str2num(inf.disp);
        catch
        end
    end
catch
    disp(['Dispersion load failed or wrong input, tried to laod',Dispersion_Used])
    disp(inf.Probe)
    return
end

BytesPerPixel = str2double(extractBefore(extractAfter(inf.Header,'<BytesPerPixel>'),'</BytesPerPixel>'));
if BytesPerPixel == 1
    ltypespectral = 'uint8';
elseif BytesPerPixel == 2
    ltypespectral = 'uint16';
end
ChirpN = single(linspace(0,round(size(Chirp,1))-1,round(size(Chirp,1))));
SE = str2double(extractBefore(extractAfter(inf.Header,'<SpectrometerElements>'),'</SpectrometerElements>'));
BtECS = str2double(extractBefore(extractAfter(inf.Header,'<BinaryToElectronCountScaling>'),'</BinaryToElectronCountScaling>'));
inf.Comment = extractBefore(extractAfter(inf.Header,'<Comment>'),'</Comment>');
File = string(inf.file{inf.i});
File = erase(File,'.oct');
Path = string(inf.path);

Model = extractBefore(extractAfter(inf.Header,'<Model>'),'</Model>');
if contains(Model,'GAN600')
    Size = extractBefore(extractAfter(inf.Header,'<SizePixel Unit="px">'),'</SizePixel>');
    inf.SizeZ = str2double(extractBefore(extractAfter(Size,'<SizeZ>'),'</SizeZ>'));
    inf.SizeX = str2double(extractBefore(extractAfter(Size,'<SizeX>'),'</SizeX>'));
    inf.SizeY = str2double(extractBefore(extractAfter(Size,'<SizeY>'),'</SizeY>'));
    if isnan(inf.SizeY)
        inf.SizeY = 1;
    end
    inf.SizeZ_real = str2double(extractBefore(extractAfter(inf.Header,'RangeZ="'),'"'));
    inf.SizeX_real = str2double(extractBefore(extractAfter(inf.Header,'RangeX="'),'"'));
    inf.SizeY_real = str2double(extractBefore(extractAfter(inf.Header,'RangeY="'),'"'));
elseif contains(Model,'Hyperion_V1') || contains(Model,'Ganymed-III_V1')
    Size = extractBefore(extractAfter(inf.Header,'<SizePixel Unit="mm">'),'</SizePixel>');
    inf.SizeZ = str2num(extractBefore(extractAfter(Size,'<SizeZ>'),'</SizeZ>'));
    inf.SizeX = str2num(extractBefore(extractAfter(Size,'<SizeX>'),'</SizeX>'));
    inf.SizeY = str2num(extractBefore(extractAfter(Size,'<SizeY>'),'</SizeY>'));
    inf.SizeZ_real = inf.SizeZ ;
    inf.SizeX_real = inf.SizeX ;
    inf.SizeY_real = inf.SizeY;
    if isnan(inf.SizeY)
        inf.SizeY = 1;
    end
end

inf.SpeckleAveraging = extractBefore(extractAfter(inf.Header,'<SpeckleAveraging>'),'</SpeckleAveraging>');
inf.SaSA = str2double(extractBefore(extractAfter(inf.SpeckleAveraging,'<SlowAxis>'),'</SlowAxis>')); % Averaging Slow Axis
inf.SaFA = str2double(extractBefore(extractAfter(inf.SpeckleAveraging,'<FastAxis>'),'</FastAxis>')); % Averaging Slow Axis
if isnan(inf.SaSA)
    inf.SaSA = 1;
end
Apo(1) = str2double(extractBefore(extractAfter(inf.Header,'ApoRegionStart0="'),'"'))+1; % Averaging Slow Axis
Apo(2) = str2double(extractBefore(extractAfter(inf.Header,'ApoRegionEnd0="'),'"'))+1; % Averaging Slow Axis

inf.CameraLineRate = str2num(extractBefore(extractAfter(inf.Header,'<CameraLineRate>'),'</CameraLineRate>'));

inf.CenterX = str2num(extractBefore(extractAfter(inf.Header,'<CenterX>'),'</CenterX>'));
inf.CenterY = str2num(extractBefore(extractAfter(inf.Header,'<CenterY>'),'</CenterY>'));

inf.MetaInfo = extractBefore(extractAfter(inf.Header,'<MetaInfo>'),'</MetaInfo>');
inf.MetaInfoAcquisitionMode = extractBefore(extractAfter(inf.MetaInfo,'<AcquisitionMode>'),'</AcquisitionMode>');


% inf.CenterX = str2num(extractBefore(extractAfter(inf.Header,'<CenterX>'),'</CenterX>'));

if strcmp(inf.extract_info,'on')
    fclose(fileID);
    raw = 0;
    return;
end


% Processing Start
fseek(fileID,0,'bof'); % go back to init of file

% Check for horror
if ~isequal(size(Chirp), [SE,1])
    Chirp = Chirp';
end
if ~isequal(size(ChirpN), [SE,1])
    ChirpN = ChirpN';
end
if ~isequal(size(Offset), [SE,1])
    Offset = Offset';
end

try
    mkdir(fullfile(Path,File))
catch
end

k=1;

fseek(fileID,0,'bof'); % go back to init of file
try
    for i=1:size(List,1)
        fseek(fileID,4,'cof');    %Local_file_inf.Header = typecast(fread(fileID,4,'uint8=>uint8'),'uint32');
        fseek(fileID,2,'cof');    %Version_needed = typecast(fread(fileID,2,'uint8=>uint8'),'uint16');
        fseek(fileID,2,'cof');    %Gpbf = typecast(fread(fileID,2,'uint8=>uint8'),'uint16');
        fseek(fileID,2,'cof');    %Compression_method = typecast(fread(fileID,2,'uint8=>uint8'),'uint16');
        fseek(fileID,2,'cof');    %Flmt = typecast(fread(fileID,2,'uint8=>uint8'),'uint16');
        fseek(fileID,2,'cof');    %Flmd = typecast(fread(fileID,2,'uint8=>uint8'),'uint16');
        fseek(fileID,4,'cof');    %CRC32 = typecast(fread(fileID,4,'uint8=>uint8'),'uint32');
        Cs = typecast(fread(fileID,4,'uint8=>uint8'),'uint32');
        Us = typecast(fread(fileID,4,'uint8=>uint8'),'uint32');
        Fnl = typecast(fread(fileID,2,'uint8=>uint8'),'uint16');
        Efl = typecast(fread(fileID,2,'uint8=>uint8'),'uint16');
        File_name = strcat(fread(fileID,Fnl,'*char'))'; % read File Name
        Extra_field = typecast(fread(fileID,Efl,'uint8=>uint8'),'uint8');
        
        inf.interp_par = 'spline';
        
        if contains(File_name,'Spectral') && k<=inf.SizeY*inf.SaSA
            bscan = typecast(fread(fileID,Cs,'uint8=>uint8'),ltypespectral);
            spectrum(i,:) = bscan;
            if strcmp(inf.disp,'Calc or put dispersion here') && k==1 % only correct first Bscan
                inf.Dispersion = dispersion_correction_image(inf,bscan,Offset,Chirp,ChirpN,inf.Dispersion,SE,inf.b_a,inf.b_b,inf.interp_par,BtECS,File_name,File,Path,Apo,inf.process_complex,spectrometer,inf.proc.half);
                if strcmp(inf.Dispersion,'Dispersion return')
                    return
                end
            elseif strcmp(inf.disp,'Experimental')
                rec1(k,bscan,Offset,Chirp,ChirpN,inf.Dispersion,SE,inf.b_a,inf.b_b,inf.interp_par,BtECS,File_name,File,Path,Apo,inf.process_complex,spectrometer,inf.proc.half);
                %                 rec2(i,bscan,Offset,Chirp,inf.Dispersion,inf.b_a,inf.b_b,BtECS,File_name,File,Path,Apo,inf.process_complex,spectrometer);
            elseif strcmp(inf.disp,'GUI')
                dispersion_correction_image_gui(inf,bscan,Offset,Chirp,ChirpN,inf.Dispersion,SE,inf.b_a,inf.b_b,inf.interp_par,BtECS,File_name,File,Path,Apo,inf.process_complex,spectrometer,inf.proc.half)
                return
            end
            k =k+1;
        else
            if contains(File_name,'Apodization') || contains(File_name,'Chirp') ||contains(File_name,'OffsetErrors.data')
                ltype = 'single';
                raw{i,2} = (typecast(fread(fileID,Cs,'uint8=>uint8'),ltype));
            elseif contains(File_name,'Probe.ini') || contains(File_name,'Header.xml')
                ltype = '*char';
                raw{i,2} = convertCharsToStrings(fread(fileID,Cs,ltype));
            elseif contains(File_name,'Video') || contains(File_name,'PreviewImage')
                ltype = 'uint8';
                fread(fileID,Cs,ltype);
            end
        end
    end
catch
    disp('Could not process all files')
end
start_points = [0 0 0 0 0];
inf.proc.save = 'off';
func = @(start_points)  f_dispersion_correction(spectrum,raw,BtECS,Offset,inf,Chirp,ChirpN,spectrometer,List,Path,File,start_points);
output = fminsearch(func,start_points);
inf.disp = output*1000000;
inf.disp = 0;
inf.proc.save = 'on';
f_reconstruction(spectrum,raw,BtECS,Offset,inf,Chirp,ChirpN,spectrometer,List,Path,File);

fclose(fileID);
if size(inf.file,1) == 1
    %delete(p)
end
%profile viewer
inf.SizeZ = 1024;
save(fullfile(inf.path,[inf.file{inf.i}(1:end-4),'_inf.mat']),'inf');
toc
end

function [output] = f_dispersion_correction(spectrum,raw,BtECS,Offset,inf,Chirp,ChirpN,spectrometer,List,Path,File,start_points)
inf.disp = start_points*1000000;
interp_par = 'spline';
if strcmp(inf.rec,'1')
    [image] = f_reconstruction(spectrum,raw,BtECS,Offset,inf,Chirp,ChirpN,spectrometer,List,Path,File);
elseif strcmp(inf.rec,'2')
    [image] = f_reconstruction(spectrum,raw,BtECS,Offset,inf,Chirp,ChirpN,spectrometer,List,Path,File);
end
figure(1);
subplot(2,2,1)
imagesc(octa(image))
subplot(2,2,3:4)
plot(octa(mean(image,2)))
title(num2str(round(inf.disp)))
if strcmp(spectrometer,'xposure')
    image = double((image(inf.disp_corr_window(2):inf.disp_corr_window(2)+inf.disp_corr_window(4),:)));
    %     output = -entropy(double(octa(image)));
    output = -entropy(octa(image));
    subplot(2,2,3:4)
    title(output*1000)
else
    %output = -entropy(double((image(inf.disp_corr_window(2):inf.disp_corr_window(2)+inf.disp_corr_window(4),inf.disp_corr_window(1):inf.disp_corr_window(1)+inf.disp_corr_window(3)))));
    output = -max(octa(mean(image(:,1:50),2)));
end
end

function [b_scan] = f_reconstruction(spectrum,raw,BtECS,Offset,inf,Chirp,ChirpN,spectrometer,List,Path,File)
for i = 1:1 %size(spectrum,1)
    b_scan = single(reshape(spectrum(i,:),[2048 length(spectrum(i,:))/2048]))*(BtECS) - Offset;
    apo = raw{11,2};
    if strcmp(spectrometer,'Thorlabs')
        b_scan = b_scan-apo;
        b_scan = b_scan.*ApoVector(apo,single(BtECS)); % Apodisierung
    elseif strcmp(spectrometer,'xposure')
        b_scan = b_scan(:,Apo(2):end);
        apo = movmean(mean(b_scan,2),[20 1]);
        b_scan = (b_scan - apo);
        h = hann(1800);
        hh = 0.*linspace(1,2048,2048);
        hh(1024) = 1;
        hh = conv(hh,h,'same');
        b_scan = b_scan.*hh';
    end
    b_scan = filter(inf.b_b,inf.b_a,b_scan); % Numerical high-pass filter
    b_scan = b_scan.*DispVector(inf.disp,Chirp,size(b_scan,2)); % hard coded dispersion compensation
    b_scan = interp1(Chirp,b_scan,ChirpN,inf.interp_par); % lambda2k Interpolation
    b_scan(isinf(b_scan)) = 0;
    b_scan(isnan(b_scan)) = 0;
    b_scan = ifft(b_scan,2048,1); % k-space-Reconstruction
    if strcmp(inf.process_complex,'on') && strcmp(inf.proc.half,'on')
        b_scan = b_scan(1:round(size(b_scan,1)/2),:);
    elseif strcmp(inf.process_complex,'on') && strcmp(inf.proc.half,'off')
        b_scan = b_scan(:,:);
    elseif strcmp(inf.process_complex,'off')
        b_scan = abs(b_scan(1:round(size(b_scan,1)/2),:));
    end
    File_nr= erase(List{i,1},'data\Spectral');
    File_nr = string(erase(File_nr,'.data'));
    % save(fullfile(Path,File,strcat(File_nr,'.mat')),'b_scan','-v4');
    if strcmp(inf.proc.save,'on')
        save(fullfile(Path,File,strcat(File_nr,'.mat')),'b_scan','-v7.3','-nocompression');
    end
end
end