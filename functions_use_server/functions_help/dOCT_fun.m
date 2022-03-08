function [output] = dOCT_fun(input,version)
% Frequency based evaluation
try
    clc;
    %%
    if version==0  % Simple frequency based evaluation
        input = abs(input(:,:,:));
        input = fft(input,size(input,3),3);
        input = input(1:size(input,1),:,:);
        
        b = sum(abs(input(:,:,1:1)),3);
        g = sum(abs(input(:,:,1:9)),3);
        r = sum(abs(input(:,:,1:34)),3);
        
        b = b;
        g = g-b;
        r = r-g-b;
        
        % h = fspecial('gaussian',[3 3]);
        % r = conv2(r,h,'same');
        % g = conv2(g,h,'same');
        % b = conv2(b,h,'same');
        
        output = cat(3,r,g,b);
    elseif version == 1 % Simple Standard deviation
        Raw = reshape(Raw,[inf.SizeZ inf.SizeX inf.SaSA inf.SizeY]);
        Raw = squeeze(std(Raw,0,3));
        figure(1)
        subplot(1,2,1)
        imagesc(squeeze(max(Raw,[],1)));
        axis equal tight
        colormap gray
        title(string(file));
        
    else
        disp('Wrong version')
    end
catch
end
%% Extend
end