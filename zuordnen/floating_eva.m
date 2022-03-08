%%
for ii=3:3
    Raw = Set{ii,4}(301:800,:,:);
    %%
    k = 1;
    % Raw = Set{6,4};
    clearvars c_a
    inf.postprocessing.image_registration = 0;
    for i=1:size(Raw,3)-149
        Raw_process = Raw(:,:,i:i+149);
        if inf.postprocessing.image_registration == 1
            [Raw_process] = registration_b_scans(Raw_process);
        end
        %c =  dOCT(Raw(1:1024,:,:),0);
        c = dOCT_fun(Raw_process(:,:,:),0);
        c_a(:,:,:,k) = c;
        k = k+1;
    end
    %%
    test = c_a;
    for rgb=1:3
        test(:,:,rgb,:) = log(test(:,:,rgb,:)+1);
        test(:,:,rgb,:) = test(:,:,rgb,:)-min(min(min(test(:,:,rgb,:))));
        test(:,:,rgb,:) = test(:,:,rgb,:)./max(max(max(test(:,:,rgb,:))));
    end
    implay(test)
    
    %%
    options.color     = true;
    options.compress  = 'no';
    options.message   = true;
    options.append    = false;
    options.overwrite = true;
    options.big       = true;
%     res = saveTiffStack(permute(test(:,:,:,:),[1 2 3 4]),[num2str(ii),'.tif'], options);
end
