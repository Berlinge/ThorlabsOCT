clc; clearvars;
%% import from measurement as excel file
folder = 'Z:\2020-12-29\xposure\001\';

for i=1:8
    file = [num2str(i),'.xlsx'];
    T = table2array(readtable(strcat(folder,file)));
    T = mean(T(250:260,:),1);
    import{i,:} = T;
end
%%
%
figure(1), clf(1);
subplot(2,1,1)
for i=1:size(import,1)
    plot(import{i,1}(:,250,1))
    x = [87 120];
    import{i,2} = max(import{i,1}(x(1):x(2)));
    import{i,3} = mean([import{i,1}(x(1)),import{i,1}(x(2))]);
    import{i,4} =  import{i,2}- import{i,3}; 
    hold on
end
xlim([1 1024])
ylim([-10 110])

subplot(2,1,2)
for i=1:size(import,1)
    plot(i,import{i,2}-import{i,3},'.k')
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

A_scan_rate = [600 500 400 300 200 100 50 25];
tau_i = ((1./(A_scan_rate.*10^3)))*3./3; % Belichtungszeit in us 
tau_i = [1.1 1.8 2.3 2.8 3.9 6.9 12 18]*10^-6; % Messwerte aus dem Messbuch (29.12.2020)
subplot(2,1,2)
for i=1:size(import,1)
    tau = tau_i(i);
    i_d = import{i,2}-import{i,3};
    sens_max = (i_d)-20*log10(R)+20*OD;
    sens_max_theorie = 10*log10((eta*P_Probe*tau)/(4*E_v));
    plot(i,sens_max,'.g')
    hold on
    plot(i,sens_max_theorie,'.r')
    hold on
end

xticks(linspace(1,size(import,1),size(import,1)))
xticklabels(A_scan_rate)