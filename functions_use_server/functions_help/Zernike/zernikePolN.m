function [ Z ] = zernikePolN(n,sizeX,sizeY)
%zernikePOLN Returns teh nth zernike polinomial
%
x = linspace(-1,1,sizeX);
y = linspace(-1,1,sizeY);
[X,Y] = meshgrid(y,x);
[theta,r] = cart2pol(X,Y);
idx = r<=1;
Z = zeros(size(X));
Z(idx) = zernfun2(n,r(idx),theta(idx));
% figure
% pcolor(y,x,Z), shading interp
% axis square, colorbar
end

