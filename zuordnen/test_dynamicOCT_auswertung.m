clc; clearvars -except Raw back;

n = 25;
ii=1;
for n=1:1:150
    
    data = Raw(:,:,1:n);
    h = hann(n);
    % h = ones(150,1);
    for z=1:1024
        for x=1:500
            data(z,x,:) = squeeze(data(z,x,:)).*h;
        end
    end
    clear z x
    fft_data = fft(data,1024,3);
    % fft_data = fft_data(:,:,round((size(fft_data,3)+1)/2):end);
    %
    T = 1.38; % Aufnahmezeit
    N = 150; % Aufnahmesamples
    delta_t = T/N;
    frequency = 1/delta_t;
    n_frequency = 1/2*frequency;

    k = linspace(0,n_frequency,size(fft_data,3));

    cut_off_frequencies = [0.5 5 25];

    for i=1:3
        [~,ix(i)] = min(abs(k-cut_off_frequencies(i)));
    end

    rgb(:,:,3) = sum(abs(fft_data(:,:,1:ix(1))),3);
    rgb(:,:,2) = sum(abs(fft_data(:,:,ix(1)+1:ix(2))),3);
    rgb(:,:,1) = sum(abs(fft_data(:,:,ix(2)+1:ix(3))),3);

    % rgb = histeq(rgb);

    save_data(:,:,:,ii) = rgb;

    for i=1:3
        rgb(:,:,i) = (rgb(:,:,i)-min(min(rgb(:,:,i))));
        rgb(:,:,i) = rgb(:,:,i)./max(max(rgb(:,:,i)));
        rgb(:,:,i) = log(rgb(:,:,i)+1);
        rgb(:,:,i) = (rgb(:,:,i)-min(min(rgb(:,:,i))));
        rgb(:,:,i) = rgb(:,:,i)./max(max(rgb(:,:,i)));
        rgb(:,:,i) = medfilt2(rgb(:,:,i));
    end
    % Vergleich schwierig, da die einzelnen Farbkanäle genormt werden

    imagesc(rgb)
    title(num2str(n))
    axis equal tight
    pause(0.1)
    ii = ii+1;
end