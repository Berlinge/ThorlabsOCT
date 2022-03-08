for i=2:size(Set,1)
    Data = Set{i,4};
    Data = log(abs(fft(octa(Data),150,3)));
    Data = Data(:,:,1:75);
    Data = movmean(Data,5,3);
    [x,ind] = max(Data(:,:,10:50),[],3);
    ind(x<2) = 0;
    Set{i,5} = ind;    
end

%%
clearvars S
for i=2:size(Set,1)
    S(:,:,i-1) = Set{i,5};
end
implay(S)


%% Test
for i=10
    Data = Set{i,4};
    implay(octa(Data))
    Data = log(abs(fft((Data),150,3)));
    Data = Data(:,:,1:75);
    Data = movmean(Data,5,3);
    [x,ind] = max(Data(:,:,10:50),[],3);
    ind(x<3) = 0;
    ind(x>20) = 0;
    ind(ind<3) = 0;
    ind(ind>15) = 0;
    imagesc(ind)
    axis equal tight
    colorbar
end
