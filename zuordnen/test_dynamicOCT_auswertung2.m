back2 = save_data;
%%
save_data = back2;
for ii=1:size(save_data,4)
    for i=1:3
        save_data(:,:,i,ii) = (save_data(:,:,i,ii)-min(min(save_data(:,:,i,ii))));
        save_data(:,:,i,:) = save_data(:,:,i,:)./max(max(max(save_data(:,:,i,:))));
        save_data(:,:,i,ii) = log(save_data(:,:,i,ii)+1);
        save_data(:,:,i,ii) = (save_data(:,:,i,ii)-min(min(save_data(:,:,i,ii))));
        save_data(:,:,i,:) = save_data(:,:,i,:)./max(max(max(save_data(:,:,i,:))));
        save_data(:,:,i,ii) = medfilt2(save_data(:,:,i,ii));
    end
end
%%
for i=1:size(save_data,4)
    imagesc(squeeze(save_data(:,:,:,i)))
    title(num2str(i))
    pause(0.01)
end