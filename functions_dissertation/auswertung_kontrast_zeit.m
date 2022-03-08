clearvars
load('E:\OneDrive\Dissertation\Daten\2019-11-19 Zunge 28 Phasenkorrigiert mit Alg.mat')
%% auswertung_zeit_contrast
mag = abs(Raw(1:1024,:,:));

z = 441:470;
x = 1:500;
z_noise = 254:283;
x_noise = 1:500;

clc;
figure(5), clf(5)

image = 20.*log10(mean(mag,3));
image = (image-min(image(:)))./(max(image-min(image(:))));
subplot(1,2,1)
imagesc(image)
axis equal tight
colormap gray; colorbar

hold on
rectangle('Position',[x(1) z(1) length(x) length(z)],'EdgeColor','black')
rectangle('Position',[x_noise(1) z_noise(1) length(x_noise) length(z_noise)],'EdgeColor','red')
hold off

for t=1:10
    % PCA
    mag_part = mag(:,:,1:t);
    mag_pca = pca(reshape(permute(mag_part,[3 1 2]),[size(mag_part,3) size(mag_part,1)*size(mag_part,2)]));
    mag_pca = reshape(mag_pca(:,:,:),[size(mag_part,1) size(mag_part,2) size(mag_part,3)-1]);
    mag_pca = std(mag_pca(:,:,2:end),0,3);
    mag_pca = medfilt2((mag_pca),[3 3]);
    mag_pca = log(mag_pca+1);
    mag_pca = (mag_pca-min(mag_pca(:)))./max(max(mag_pca-min(mag_pca(:))));
    

        cont = std(mag_pca(z,x),0,'all')./mean(mag_pca(z,x),'all');
        m_s = mean(mag_pca(z,x),'all');
        m_b = mean(mag_pca(z_noise,x_noise),'all');
        sigma_s = std(mag_pca(z,x),0,'all');
        sigma_b = std(mag_pca(z_noise,x_noise),0,'all');
        C(t) = cont;
        CNR(t) = (m_s-m_b)./sqrt(sigma_s.^2+sigma_b.^2);
    
    % STD
    image = log(std(mag(:,:,1:t),0,3)+1);
    image = (image-min(image(:)))./max(max(image-min(image(:))));
    
        cont = std(image(z,x),0,'all')./mean(image(z,x),'all');
        m_s = mean(image(z,x),'all');
        m_b = mean(image(z_noise,x_noise),'all');
        sigma_s = std(image(z,x),0,'all');
        sigma_b = std(image(z_noise,x_noise),0,'all');
        C_std(t) = cont;
        CNR_std(t) = (m_s-m_b)./sqrt(sigma_s.^2+sigma_b.^2);
    
    % MEAN Int
    image = (mean(mag(:,:,1:t),3));
    image = (image-min(image(:)))./max(max(image-min(image(:))));
    
        cont = std(image(z,x),0,'all')./mean(image(z,x),'all');
        m_s = mean(image(z,x),'all');
        m_b = mean(image(z_noise,x_noise),'all');
        sigma_s = std(image(z,x),0,'all');
        sigma_b = std(image(z_noise,x_noise),0,'all');
        C_std(t) = cont;
        CNR_mean(t) = (m_s-m_b)./sqrt(sigma_s.^2+sigma_b.^2);
           
    % MEAN 20log10(Int)
    image = 20.*log10(mean(mag(:,:,1:t),3)+1);
    %image = (mean(mag(:,:,1:t),3));
    image = (image-min(image(:)))./max(max(image-min(image(:))));
    
        cont = std(image(z,x),0,'all')./mean(image(z,x),'all');
        m_s = mean(image(z,x),'all');
        m_b = mean(image(z_noise,x_noise),'all');
        sigma_s = std(image(z,x),0,'all');
        sigma_b = std(image(z_noise,x_noise),0,'all');
        C_std(t) = cont;
        CNR_log_mean(t) = (m_s-m_b)./sqrt(sigma_s.^2+sigma_b.^2);
    
    subplot(1,2,2)
    imagesc(mag_pca)
    axis equal tight
    colormap gray; colorbar
    
    hold on
    rectangle('Position',[x(1) z(1) length(x) length(z)],'EdgeColor','black')
    rectangle('Position',[x_noise(1) z_noise(1) length(x_noise) length(z_noise)],'EdgeColor','red')
    hold off
end

%
%%
figure
plot(CNR)
hold on
plot(CNR_std)
plot(CNR_mean)
% plot(CNR_log_mean)

legend('pca','std','mean')