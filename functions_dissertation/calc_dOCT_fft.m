function [output] = calc_dOCT_fft(input,Hz) % 23 Hz bei 30 kZ Specklevarianz und 108 Hz bei 100 kHz B-scans
%CALC_DOCT Summary of this function goes here
%   Detailed explanation goes here

%1/(size(input,2)/(inf.CameraLineRate)+25/(inf.CameraLineRate)+2*0.002);
% HZ = A_scan_rates+2*flyback_time+25 Apo

Hz_l = [0.5 5 25];
sampling = linspace(0,Hz,size(input,length(size(input)))); % A_scan rate: 100 kHz und 500 A-scans / B-scan
for i=1:3
[~,I(i)] = min(abs(sampling-Hz_l(i)));
end

input = fftshift(fft(input,100,3),3);
b_hlp = sum(abs(input(:,:,1:I(1))),3);
g_hlp = sum(abs(input(:,:,1:I(2))),3);
r_hlp = sum(abs(input(:,:,1:I(3))),3);

b = b_hlp;
g = g_hlp-b_hlp;
r = r_hlp-g_hlp;

r = log(r);
g = log(g);
b = log(b);

r = r-min(r(:));
g = g-min(g(:));
b = b-min(b(:));

r = r./max(r(:));
g = g./max(g(:));
b = b./max(b(:));

output = cat(3,r,g,b);

% imagesc(output)
% axis equal tight

end

