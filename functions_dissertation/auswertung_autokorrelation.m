
x = 350;
y = 50;
t = squeeze(enface(x,y,:));

at = fftshift(ifft(fft(t).*conj(fft(t))));
at = at(51:end);
% at = at./max(at);

dx = -12;
dy = 30;
at2 = fftshift(ifft(fft(squeeze(enface(x+dx,y+dy,:))).*conj(fft(squeeze(enface(x+dx,y+dy,:))))));
at2 = at2(51:end);
at2 = at2./max(at2);

figure(1), clf(1);
imagesc(log(std(enface,0,3)))
colormap gray
axis equal tight
hold on
plot(y, x, 'bx', 'MarkerSize', 5);
plot(y+dy, x+dx, 'rx', 'MarkerSize', 5);
hold off

figure(2), clf(2);
plot(t);

figure(3), clf(3);
plot(at)
hold on
plot(at2)
hold off

figure(4), clf(4);
% for x=1:500
%     for y=1:550
%         m(x,y) = max(xcorr(t,squeeze(enface(x,y,:))));
%     end
% end
% plot(xcorr(t,squeeze(enface(451,50,:))))
%%
clc;
for x=1:500
    parfor y=1:550
        t = squeeze(enface(x,y,:));
        at = fftshift(ifft(fft(t).*conj(fft(t))));
        at = double(at(51:end));
        %at = double(at./max(at));
        
        [xData, yData] = prepareCurveData( [], at );
        
        % Set up fittype and options.
        ft = fittype( 'power2' );
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
        opts.Display = 'Off';
        %opts.StartPoint = [1.00221229935629 -0.00882650480504665];
        
        % Fit model to data.
        [fitresult, gof] = fit( xData, yData, ft, opts );
        A(x,y) = fitresult.a;
        B(x,y) = fitresult.b;
        C(x,y) = fitresult.c;
    end
    x
end
%%
figure(4), clf(4);
imagesc(log(abs(B)))
colormap gray
axis equal tight