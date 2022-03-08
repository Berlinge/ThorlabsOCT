function [output] = calc_dOCT_pca(input,Hz) % 23 Hz bei 30 kZ Specklevarianz und 108 Hz bei 100 kHz B-scans
%CALC_DOCT Summary of this function goes here
%   Detailed explanation goes here

%1/(size(input,2)/(inf.CameraLineRate)+25/(inf.CameraLineRate)+2*0.002);
% HZ = A_scan_rates+2*flyback_time+25 Apo

output = pca(reshape(permute(input,[3 1 2]),[size(input,3) size(input,1)*size(input,2)]));
output = reshape(output(:,:,:),[size(input,1) size(input,2) size(input,3)-1]);
output = std(output(:,:,2:end),0,3);
% mag = medfilt2((mag),[3 3]);
output = log(output);
output = (output-min(output(:)))./max(max(output-min(output(:))));

% imagesc(output)
% colormap gray
% colorbar
% axis equal tight

end

