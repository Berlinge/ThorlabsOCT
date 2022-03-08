function [inf,raw] = xposure_raw(inf)
%XPOSURE Summary of this function goes here
%   Detailed explanation goes here
clc;
% read inf files
spectrometer = 'xposure';
File = string(inf.file{inf.i});
File = erase(File,'.raw');
Path = string(inf.path);

s = dir(fullfile(inf.path,[inf.file{inf.i}(1:end-4),'.xml']));
s = s.bytes;
fileID = fopen(fullfile(inf.path,[inf.file{inf.i}(1:end-4),'.xml']));
s = convertCharsToStrings(fread(fileID,s,'*char'));

inf.SizeX_real = str2double(erase(extractBefore(extractAfter(s,'<Name>x_steps</Name>'),'</Val>'),'<Val>'));
inf.SizeY_real = str2double(erase(extractBefore(extractAfter(s,'<Name>y_steps</Name>'),'</Val>'),'<Val>'));
inf.SizeZ_real = 2048/2;
inf.CameraLineRate = str2double(erase(extractBefore(extractAfter(s,'<Name>frequency</Name>'),'</Val>'),'<Val>'));
inf.CenterX = 0;
inf.CenterX = 0;
inf.Comment = erase(extractBefore(extractAfter(s,'<Name>Comment</Name>'),'</Val>'),'<Val>');

if strcmp(inf.extract_info,'on')
    fclose(fileID);
    raw = 0;
    return;
end

[xml] = xml2struct(fullfile(inf.path,[inf.file{inf.i}(1:end-4),'.xml']));
[inf.id1,inf.id2,inf.id3,inf.id4] = xml_import(xml);

SE = 2048; % spectrometer elements
ChirpN = single(linspace(0,SE-1,SE))';
% BtECS = 13000;
BtECS = single(inf.id1{[inf.id1{:}]=="Electrons",2});
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
        inf.Dispersion = str2num(inf.disp);
    end
catch
    disp(['Dispersion load failed or wrong input, tried to laod',Dispersion_Used])
    disp(inf.Probe)
    return
end

inf.Frame_Heigh = single(inf.id1{[inf.id1{:}]=="Height",2});
inf.Frame_Heigh = 3000; 
Chirp = single(inf.id3{[inf.id3{:}]=="Chirp",2});
Offset = single(inf.id3{[inf.id3{:}]=="D Dark",2})'*BtECS;

%%% extract for inf
% inf.CameraLineRate = 600000;
inf.CameraLineRate =  single(inf.id1{[inf.id1{:}]=="frequency",2});
inf.CenterX = 0;
inf.CenterX = 0;
inf.Comment = inf.id4{[inf.id4{:}]=="Comment",2};

trailing_ascans = 10; % additional apx after each frame to allow interpolation of the 3px gap
fileID=fopen(fullfile(inf.path,inf.file{inf.i}),'r');
k = dir(fullfile(inf.path,inf.file{1,1}));
k.bytes;
k = k.bytes/(inf.Frame_Heigh*SE); % Anzahl aufgenommener Frames der Kamera
inf.SizeY = k-1; % Analog zu Anzahl B-Scans
inf.SizeZ = SE./2;
inf.SaSA = 1;
inf.SizeX = inf.Frame_Heigh+3;
idx = 1;

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

try
    p = gcp();
catch
    p = parpool();
end
tic
%wb = waitbar(0,'Start Processing...');
kk = 1;
for i=1:k
    if i<k
        I = fread(fileID,SE*(inf.Frame_Heigh+trailing_ascans),'uint8=>uint8'); % read in frame+trailing_px
        %I = fread(fileID,SE*(inf.Frame_Heigh+trailing_ascans),'uint8=>uint8'); % read in frame+trailing_px
        fseek(fileID,-SE*trailing_ascans,'cof'); % dial file pointer back -offset*bytes(uint8) from current position
        I = reshape(I,SE,inf.Frame_Heigh+trailing_ascans);
        gap = cat(2,single(I(:,1+end-2*trailing_ascans:end-trailing_ascans)),... % Now interpolate/fill gap between data and trailing ascans
            NaN(SE,3),single(I(:,1+end-trailing_ascans:end)));
        %%%% DEBUG % f_h = figure(); subplot(1,2,1); surf(gap)
        gap = fillmissing(gap,'spline',2);
        % %%% DEBUG % subplot(1,2,2);surf(gap) % expand I by the interpolation result for the 3 ascans
        I = cat(2,I(:,1:inf.Frame_Heigh),gap(:,trailing_ascans+1:(trailing_ascans+1)+2));
        Apo = [1,26];
        apo = uint8(repmat(movmean(mean(I,2),100),1,Apo(2)-Apo(1)));
    elseif i==k % get last file
        clearvars I
        I = fread(fileID,SE*(inf.Frame_Heigh),'uint8=>uint8'); % read in frame+trailing_px
        I = reshape(I,SE,inf.Frame_Heigh);
        Apo = [1,26];
        apo = uint8(repmat(movmean(mean(I,2),100),1,Apo(2)-Apo(1)));
    end
    I = cat(2,apo,I);
    bscan = reshape(I,[1,size(I,1)*size(I,2)]);
    File_name = num2str(i-1);
    inf.interp_par = 'spline';
    
    if strcmp(inf.disp,'Calc or put dispersion here') && i==1 % only correct first Bscan
        inf.Dispersion = dispersion_correction_image(inf,bscan,Offset,Chirp,ChirpN,inf.Dispersion,SE,inf.b_a,inf.b_b,inf.interp_par,BtECS,File_name,File,Path,Apo,inf.process_complex,spectrometer,inf.proc.half);
        if strcmp(inf.Dispersion,'Dispersion return')
            return
        end
    elseif strcmp(inf.disp,'Experimental')
        rec2(k,bscan,Offset,Chirp,ChirpN,inf.Dispersion,SE,inf.b_a,inf.b_b,inf.interp_par,BtECS,File_name,File,Path,Apo,inf.process_complex,spectrometer,inf.proc.half);
        %                 rec2(i,bscan,Offset,Chirp,inf.Dispersion,inf.b_a,inf.b_b,BtECS,File_name,File,Path,Apo,inf.process_complex,spectrometer);
    elseif strcmp(inf.disp,'GUI')
        dispersion_correction_image_gui(inf,bscan,Offset,Chirp,ChirpN,inf.Dispersion,SE,inf.b_a,inf.b_b,inf.interp_par,BtECS,File_name,File,Path,Apo,inf.process_complex,spectrometer,inf.proc.half)
        return
    end
    
    %rec1(k,bscan,Offset,Chirp,ChirpN,inf.Dispersion,SE,inf.b_a,inf.b_b,inf.interp_par,BtECS,File_name,File,Path,Apo,inf.process_complex,spectrometer,inf.proc.half);
    if strcmp(inf.rec,'1')
        %f(k) = parfeval(p,@rec1,0,kk,bscan,Offset,Chirp,ChirpN,inf.Dispersion,SE,inf.b_a,inf.b_b,inf.interp_par,BtECS,File_name,File,Path,Apo,inf.process_complex,spectrometer,inf.proc.half); % Square size determined by idx
        rec1(kk,bscan,Offset,Chirp,ChirpN,inf.Dispersion,SE,inf.b_a,inf.b_b,inf.interp_par,BtECS,File_name,File,Path,Apo,inf.process_complex,spectrometer,inf.proc.half); % Square size determined by idx
    elseif strcmp(inf.rec,'2')
        f(k) = parfeval(p,@rec2,0,kk,bscan,Offset,Chirp,ChirpN,inf.Dispersion,SE,inf.b_a,inf.b_b,inf.interp_par,BtECS,File_name,File,Path,Apo,inf.process_complex,spectrometer,inf.proc.half); % Square size determined by idx
    end
    kk = kk+1;
    %waitbar(i/k,wb,'Processing your data');
    
end
% wb = waitbar(0,'Start Processing...');
% clearvars m;
% for i = 1:k-1
%     [~] = fetchNext(f);
%     waitbar(i/k,wb,'Processing your data');
% end
% close(wb)
fclose(fileID);
toc
if size(inf.file,1) == 1
    %delete(p)
end
%profile viewer
save(fullfile(inf.path,[inf.file{inf.i}(1:end-4),'_inf.mat']),'inf');
disp('Load ready');
raw = 1;
end
