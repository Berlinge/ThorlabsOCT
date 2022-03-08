clc; clearvars
figure(1); clf(1);
% Lightsource
% S_i = [-2:1:2];
% S = normpdf(S_i,0,1);

% Camera
FWC = 230000;
xi = linspace(1,2048,2048); % Kameraline
rho = 0.7; % Detektoreffizienz

% Tiefe und Reflektoren
% d = zeros(1,2048); % Tiefe [a.u.]
% d(530) = 0.8; % Reflektor an der Stelle x mit Reflektivität [a.u.]
% % d(600) = 0.2; % Reflektor an der Stelle x mit Reflektivität [a.u.]
% d = conv(d,S,'same');
% d = d*10;

% Simulate i_k
R = [30 70 300]; % Entspricht Tiefe
r = [0.8 0.3 0.2]; % Reflektivität von R[];
%---- dsplay
d = zeros(1,2048);
d(R.*2) = r;
subplot(2,2,1) % Display Raw-Signal
plot(xi(1:1024),d(1:1024)); axis tight; ylim([0 1])

i_k = (r(1)*cos(R(1).*2.*pi.*linspace(0,1,length(xi)))).^2; % Cross correlation pattern; %% Hann windows
for i=2:length(R)
    i_k(i,:) = (r(i)*cos(R(i).*2.*pi.*linspace(0,1,length(xi)))).^2; % Cross correlation pattern; %% Hann windows
end
i_k = sum(i_k);
% i_k = i_k.^2;
i_k = rho.*i_k;
i_k = i_k.*FWC;
%--- Hann windowing
h = hann(1600);
h_i = zeros(1,2048);
h_i(1025) = 1;
h_i = conv(h_i,h,'same');
i_k = i_k.*h_i;
%---- add noise
i_k = i_k+2*randn([1 2048]);
%---- display
subplot(2,2,2) % Display Raw-Signal
plot(xi,i_k); axis tight

%---- Apo
Apo = movmean(movmean(i_k,200),50);
% hold on; plot(Apo,'r');

% Reconstruction
f_z = 20*log10(abs(fftshift(ifft(i_k-Apo))));
f_z = f_z(1025:end); xi = xi(1:1024);
%---- display
subplot(2,2,3) % Display Reconstructed signal
plot(xi,f_z); axis tight; %xlim([1 2048])
ylim([-50 100])