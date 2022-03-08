clc; clearvars;

A_scan_rates = [5 10 25 50 100 200 248 600]; % A-scan Rates [kHz]
A_scan_rates = fliplr(A_scan_rates);
A_scan_rates_o = A_scan_rates; % save original values for axis
k = 200;
A_scan_rates = interp1(linspace(1,length(A_scan_rates),length(A_scan_rates)),A_scan_rates,linspace(1,length(A_scan_rates),k));

tau_i = (1./(A_scan_rates*10^3))'; % Exposure_times [us -> s]

P_Probe = linspace(5,60,5)*10^-3; % Power on sample [mW -> W]
P_Probe_o = P_Probe;
l = 200;
P_Probe = interp1(linspace(1,length(P_Probe),length(P_Probe)),P_Probe,linspace(1,length(P_Probe),l));

% tau_i = fliplr(tau_i);
eta = 1; % Quantum effiency

h = 6.62606957*10^-34;
c = 299792458;
lambda_0 = 750*10^-9;
E_v = (h*c)/lambda_0;

sens_map = 10.*log10((eta.*P_Probe.*tau_i)./(4.*E_v));

figure(1); clf(1);
imagesc(sens_map)
title(['Sensitivität (Quanteneffizienz = ',num2str(eta),')'])
xlabel('Bestrahlungsstärke [mw]')
xticks(linspace(1,length(P_Probe),length(P_Probe_o)))
xticklabels(string(round(P_Probe_o*10^3)));
ylabel('A-scan Rate [kHz]')
yticks(linspace(1,length(tau_i),length(A_scan_rates_o)));
yticklabels(string(round(A_scan_rates_o)));
h = colorbar;
ylabel(h, 'Sensitivität [dB]')