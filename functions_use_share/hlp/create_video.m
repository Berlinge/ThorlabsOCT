function [] = create_video(data,video_title)
%CREATE_video Creates a MPEG-4 video file 
%   Detailed explanation goes here
% INPUT
% data = array [x,y,z]
% video_title = 'xyz':

v = VideoWriter(video_title,'Motion JPEG AVI');
v.Quality = 100;
v.FrameRate = 60;
% v.LosslessCompression = true;
open(v);
for i=1:size(data,3)
    writeVideo(v,squeeze(data(:,:,i)))
end
close(v)
disp(['Duration: ',num2str(i/v.FrameRate),' s'])

end

