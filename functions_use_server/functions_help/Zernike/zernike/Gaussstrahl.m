function [uout ]= Gaussstrahl(uin , w0 , L)
[M,N] = size(uin);
dx = L/M;
x=-L/2:dx:L/2-dx;
[X,Y]= meshgrid(x,x);

%Berechung der Gaußverteilung
uout = uin .* exp(-(X .^2 + Y .^2)/ w0 ^2);
end