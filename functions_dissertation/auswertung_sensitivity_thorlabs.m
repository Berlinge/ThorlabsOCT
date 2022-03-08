clc; clearvars;

folder = 'Z:\2020-12-29\Thorlabs\20201229_sens_final_2\';
for i=1:7
    file = ['20201229_sens_final_2_',sprintf('%04d',i),'_Mode2D.oct'];
    file = py.zipfile.ZipFile(strcat(folder,file)); % Use python to read zip file
    file = file.open('data/Intensity.data');
    content = file.read();
    file.close();
    
    c = typecast(uint8(content),'single'); % typecast from bytes to specific type
    z = 1024; %
    x = 500;
    y = 2;
    c = reshape(reshape(c,z,length(c)/z),[z x y]);
    import{i,1} = c;
end

%
% figure(1), clf(1);
% imagesc(c(:,:,2))
% axis equal tight
% colormap gray

figure(1), clf(1);
subplot(2,1,1)
for i=1:size(import,1)
    plot(import{i,1}(:,250,1))
    x = [100 140];
    import{i,2} = max(import{i,1}(x(1):x(2),250,1));
    import{i,3} = mean([import{i,1}(x(1),250,1),import{i,1}(x(2),250,1)]);
    import{i,4} =  import{i,2}- import{i,3}; 
    hold on
end
xlim([1 1024])
ylim([-10 110])

subplot(2,1,2)
for i=1:size(import,1)
    plot(i,import{i,2}-import{i,3},'k.')
    hold on
end

%
clc,
OD = abs(log10(3.48/60));
n_1 = 1.5118; % Luft % n_1 = 1.3291; % Wasser
n_2 = 1.0003; % Luft % n_2 = 1.0003; % Wasser
R = ((n_1-n_2)/(n_1+n_2))^2; % Reflektivitaet
eta = 0.6; % Quanteneffizienz

P_Probe = 10*10^-3; % Strahlungsfluss in mW
E_v = (6.62606957*10^-34)*(299792458)/(750*10^-9); % E_v Elektronenenergie bei lambda_c = 750;
A_scan_rate = [248 200 100 50 25 10 5];
tau_i = ((1./(A_scan_rate.*10^3)))*3./3; % Belichtungszeit in us 

% subplot(2,1,2)
for i=1:size(import,1)
    
    tau = tau_i(i); % Belichtungszeit in us 

    i_d = import{i,2}-import{i,3};
    
    sens_max = (i_d)-20*log10(R)+20*OD;
    sens_max_theorie = 10*log10((eta*P_Probe*tau)/(4*E_v));
    
    plot(i,sens_max,'.g')
    hold on
    plot(i,sens_max_theorie,'.r')
    hold on
end

xticks(linspace(1,7,7))
xticklabels({'248','200','100','50','25','10','5'})
