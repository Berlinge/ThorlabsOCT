function [] = save_4d_to_tiff(input,destination)
%MTIFF wrote by Michael @ mic.muenter@uni-luebeck.de
% Summary of this function goes here
% Input: complex Volume (z,x,y)
% INPUT: par.filepath -> Filepath, wo das File abgespeichert werden soll
% [Vol, ~]= uigetvar();
%     Vol = permute(Vol,[3 1 2]);
input = (20.*log10(abs(squeeze(input(:,:,:))))); % Anpassung

% Hier wird das Histogramm auf 0 bis 255 gespreizt;
input = input+abs(min(min(min(input))));
input = (input./max(max(max(input)))).*255;
input = uint8(input);
%

Vol = reshape(input,[size(input,1) size(input,2) size(input,3)*size(input,4)]);
% Vol = cast(Vol,'uint8');
% for k=1:size(input,4)
t = Tiff(destination,'w8'); % Filename
% t = Tiff([par.filepath(1:end-4),'.tiff'],'w'); % Filename
tagstruct.ImageLength = size(input,1);
tagstruct.ImageWidth = size(input,2);
tagstruct.Photometric = Tiff.Photometric.MinIsBlack; % https://de.mathworks.com/help/matlab/ref/tiff.html
tagstruct.BitsPerSample = 8;
tagstruct.SamplesPerPixel = 1;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.Software = 'MATLAB';
tic
setTag(t,tagstruct)
write(t,squeeze(Vol(:,:,1)));
for i=2:size(Vol,3) %Write image data to the file and then close the Tiff object.
    writeDirectory(t);
    setTag(t,tagstruct)
    write(t,squeeze(Vol(:,:,i)));
end
close(t);
toc
disp('Tif File saved')
end