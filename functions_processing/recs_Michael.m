function [b_scan] = recs(i,b_scan,Offset,Chirp,ChirpN,Dispersion,SE,infa,infb,interp_par,BtECS,FileName,File,Path,Apo,complex,spectrometer,half)
% by Hinnerk Schulz-Hildebrandt
% - added parallel computing support by Michael Münter
b_scan = single(reshape(b_scan,[2048 length(b_scan)/2048]))*(BtECS) - Offset;
apo = mean(b_scan(:,Apo(1):Apo(2)-1),2);
if strcmp(spectrometer,'Thorlabs')
    b_scan = b_scan(:,Apo(2):end)-apo;
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
b_scan = filter(infb,infa,b_scan); % Numerical high-pass filter
b_scan = b_scan.*DispVector(Dispersion,Chirp,size(b_scan,2)); % hard coded dispersion compensation
b_scan = interp1(Chirp,b_scan,ChirpN,'spline'); % lambda2k Interpolation
b_scan(isinf(b_scan)) = 0;
b_scan(isnan(b_scan)) = 0;
b_scan = ifft(b_scan,SE,1); % k-space-Reconstruction
k=1;
for i=1:100:size(b_scan,2)
    b(:,k) = mean(b_scan(:,i:i+99),2);
    k = k+1;
end
b_scan = b;
if strcmp(complex,'on') && strcmp(half,'on')
    b_scan = b_scan(1:round(size(b_scan,1)/2),:);
elseif strcmp(complex,'on') && strcmp(half,'off')
    b_scan = b_scan(:,:);
elseif strcmp(complex,'off')
    b_scan = abs(b_scan(1:round(size(b_scan,1)/2),:));
end
File_nr= erase(FileName,'data\Spectral');
File_nr = string(erase(File_nr,'.data'));
% save(fullfile(Path,File,strcat(File_nr,'.mat')),'b_scan','-v4');
save(fullfile(Path,File,strcat(File_nr,'.mat')),'b_scan','-v7.3','-nocompression');
end