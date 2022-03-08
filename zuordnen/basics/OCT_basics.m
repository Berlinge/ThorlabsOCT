%% Theoretische Abschaetzung der Sensitivität nach "Methods to assess
% sensitivity of optical coherence tomography systems" Agrawal
clc; clearvars;
%%% mOCT - Basler Sprint
% eta = 0.46; % Quanteneffizienz [%] - BaslerSprint
% tau = 5.4*10^-6; % Belichtungszeit [s] - 100 kHz; 5.4*10^-6 bei 127 kHz
% lambda = 750*10^-9; % zentrale Wellenlänge [m] - mOCT
% P = 21*10^-3; % [W]

%%% Hinnerks Diss Angabe (Basler Sprint)
eta = 0.46; % Quanteneffizienz [%] - BaslerSprint
tau = 5.4*10^-6; % Belichtungszeit [s] - 100 kHz; 5.4*10^-6 bei 127 kHz
lambda = 750*10^-9; % zentrale Wellenlänge [m] - mOCT
P = 0.06*10^-3; % [W] - HInnerks Sens angabe

%%% mOCT - Octoplus
% eta = 0.8; % Quanteneffizienz [%] - Octoplus
% tau = 10*10^-6; % Belichtungszeit [s] - 100 kHz
% lambda = 750*10^-9; % zentrale Wellenlänge [m] - mOCT
% P = 40*10^-3; % [W]

%%% ThorlabsGAN210C1 - Website bei 5,5 kHz
% eta = 0.8; % Quanteneffizienz [%] - Octoplus
% tau = 182*10^-6; % Belichtungszeit bei 5,5 kHz (ThorlabsGAN210C1
% lambda = 930*10^-9; % zentrale Wellenlänge [m] - Thorlabs GAN210C1
% P = 0.5*10^-3; % [W] - nur angenommen

%%% Paper Leitgeb
% eta = 0.8; % Quanteneffizienz [%] - Octoplus
% tau = 1/3000; % [s] - Leitgeb paper (3000 Ascans)
% lambda = 800*10^-9; % [nm] Leitgeb Paper;
% P = 350*10^-6; % [W] - Paper Leitgeb Angabe

h = 6.62607015*10^-34; % Planksches Wirkungsquantum [J/s]
c = 299792458; % Lichtgeschwindigkeit [m/s]
E_v =((h*c)/lambda);
% Theoretische Abschätzung der Sensitivität
sens = 10*log10((eta*P*tau)/(4*E_v));% Faktor 4 aufgrund FFT Argumentation in Proceeding, bisher nie eine weitere Quelle dafuer gefunden
sens = 10*log10((eta*P*tau)/(4*E_v));
disp(['Sensitivität: ',num2str(sens),' dB'])
%% Theoretische Abschätzung des SNR (Hinnerks Diss)
20*(log10((200000/8)*sqrt(2048))-log10(sqrt(200000/4+55^2)))

%% Theoretische Abschaetzung der axialen Auflösung - OCT
clc, clearvars;
NA = 0.3;
lambda = 750*10^-9;
delta_z = (0.37*lambda)/NA;
disp(['Axiale Auflösung: ',num2str(delta_z*10^6),' um']);
%% Theoretische Abschaetzung der lateralen Auflösung - OCT
clc, clearvars;
NA = 0.16;
lambda = 750*10^-9;
delta_z = (0.37*lambda)/NA;
disp(['Axiale Auflösung: ',num2str(delta_z*10^6),' um']);
%% Konfokales Gating - Theoretische Abschaetzung des konfokalen Gatings - axial
clc;clearvars;
lambda = 750*10^-9; % zentrale Wellenlaenge
n = 1.3; % Brechungsindex
NA = 0.3;
alpha  = asin(NA/n);
% alpha = pi;
d = (0.62*lambda)/(n*(1-cos(alpha)));
disp(['Konfokales Field of View: \Delta z ',num2str(d*10^6),' um']) % in Mikrometern
%% Konfokales Gating - Theoretische Abschaetzung des konfokalen Gatings - lateral
clc;clearvars;
lambda = 750*10^-9; % zentrale Wellenlaenge
n = 1.3; % Brechungsindex
NA = 0.16;
alpha  = asin(NA/n);
% alpha = pi;
d = (0.62*lambda)/(n*(1-cos(alpha)));
disp(['Konfokales Field of View: \Delta z ',num2str(d*10^6),' um']) % in Mikrometern

%% Imaging depth
clc;clearvars;
lambda = 750*10^-9; % zentrale Wellenlaenge
d_lambda = 400*10^-9;
N = 2048;
% alpha = pi;
d = (1/4)*((lambda^2)/d_lambda)*N;
disp(['Tiefe: ',num2str(d*10^6),' um']) % in Mikrometern