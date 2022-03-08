alpha = 0.3;
T_1 = 0.5;
T_2 = 3;
t = linspace(0,10,100);

ACF = alpha.*exp(-(t/T_1))+(1-alpha).*exp(-(t/T_2));
plot(ACF)

%%
dt = (500*500)/600000;

timecurve = linspace(0,10,11);

%% autocorrelation nach Boccara
figure(3)
clf(3)
clearvars
tx = linspace(0,20*pi,1000);
f = linspace(0,0.1,1000);
% y = sin(x)+1;
y = fliplr(sin(2.*pi.*f.*tx));
% input = single(squeeze(L(316,20,:)));
% input = input./max(input).*100;
input = y;

N = length(input);
for tau = 1:length(y) % tau = mw
    for k=1:N-tau
        ACF(k) = input(k).*input(k+tau);
    end
    ACF = sum(ACF);
    ACF = (1/(N-tau)).*ACF;
    ACF_tau(tau) = ACF;
end
subplot(2,1,1)
plot(y)
subplot(2,1,2)
plot(ACF_tau)