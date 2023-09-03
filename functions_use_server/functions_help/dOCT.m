function [output] = dOCT(input,version)
% dOCT function
% Frequency based evaluation
% Last update: 2020-06-24
try
    clc;
    %%
    if version==0  % Simple frequency based evaluation
        input = abs(input(:,:,:));
        input = fft(input,size(input,3),3);
        input = input(1:size(input,1),:,:);
        
        testb = sum(abs(input(:,:,1:1)),3);
        testg = sum(abs(input(:,:,1:8)),3);
        testr = sum(abs(input(:,:,1:36)),3);
        
        b = testb;
        g = testg-testb;
        r = testr-testg;
                
        r = log(r);
        g = log(g);
        b = log(b);
              
        r = r-min(r(:));
        g = g-min(g(:));
        b = b-min(b(:));
        
        r = r./max(r(:));
        g = g./max(g(:));
        b = b./max(b(:));
        
        output = cat(3,r,g,b);    elseif version == 1 % Simple Standard deviation
        %%
        output = squeeze(std(input,0,3));
    elseif version == 2 % dOCT frequency based without instant scaling [0 1]
        %%
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