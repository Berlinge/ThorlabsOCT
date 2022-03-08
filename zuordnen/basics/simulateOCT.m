clear vars; clc; clf

%*
% Wir haben ein elektrisches Feld mit Amplitude A und Phasor p
% Am Detektor messen wir nur noch die Intensity I = E^2
%*
x = linspace(1,2048,2048);
FWC = 13000/100; % Full Well Capacity)
avI = 20; % average Intensity on detector
for i= 1:500
y = FWC*avI*sin((1/i).*2.*pi.*x); % hier wird die durch die interferenz hervorgefunde sinus Welle (spektrale Bestandteile) simuliert
h = hann(2000); % Hann windows -> Breitre schraenkt axiale Aufl ein
hi = linspace(0,0,2048);
hi(1025) = 1;
hi = conv(hi,h,'same'); % gib ihm den Hann 
y = y.*hi;
p = linspace(0,0,2048); 
y = y.*exp(-1i.*p); % add linear spectral phase phactor
f_y = 20*log10(abs(fftshift(ifft(y)))); % standard oct prozessierung 
subplot(2,1,1)
plot(x,real(y))
xlabel('I(\lambda / 2*k)') % Theoretisch wuerde hier die lambda 2 k Geschichte kommen
ylabel('I [a.u.]')
axis tight
% ylim([-100 100])
subplot(2,1,2)
% plot(f_y)
plot(x(1025:2048),f_y(1025:end))
ylim([-pi 100])
xlim([1025 2048]) 
xlabel('I [z]')
ylabel('I [dB]')
pause(0.1)
end