clf(1)
t = linspace(550,950,2048);
t_r = linspace(1,2048,2048);
t_x = t;
t(:) = 1;

h = hann(500);
hh = 0*linspace(1,2048,2048);
hh(1024) = 1;
hh = conv(hh,h,'same');
t = t.*hh;

plot(t);
k = 100;
xticks(t_r(1:k:end))
xticklabels(num2cell(round(t_x(1:k:end))))
xlim([1 2048])
%axis equal tight

lambda_c = 750*10^-9;
delta_lambda = 150*10^-9;

ax = (2.*log(2)/pi)*(lambda_c^2/delta_lambda);
ax = ax*10^6;