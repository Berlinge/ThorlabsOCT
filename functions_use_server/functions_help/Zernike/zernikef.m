function [Vq] = zernikef( n, m, sizeIm)

%zernike
% clc
% clear variables
% clf('reset')

x = -1:0.001:1;
[X,Y] = meshgrid(x,x);
[phi,rho] = cart2pol(X,Y);

% n = 2;
% m = 0;
s = (n-m)/2;

if ( s == floor(s) )
    if ( (n-s) == floor(n-s) )
        if m>=0
            F = @(rho,phi,m,n)  R(rho,n,m) .* cos(m .* phi);
            Z = F(rho,phi,m,n);
            Z(rho>1) = nan;
            %             [x, y] = pol2cart(phi, rho);
            %             surf(x, y, Z);
            %imagesc(Z);
            %view(0,90)
            %             axis equal tight
            %             title(['R^{m = ',num2str(m),'}','_{n= ',num2str(n),'} (gerade)'])
            %             colorbar
            %             colormap winter;
            %             shading interp;
        elseif m<0
            F = @(rho,phi,m,n)  R(rho,n,m) .* sin(m .* phi);
            Z = F(rho,phi,m,n);
            Z(rho>1) = nan;
            [x, y] = pol2cart(phi, rho);
            % %             surf(x, y, Z);
            %imagesc(Z)
            %             view(0,90)
            %             axis equal tight
            %             title(['R^{m = ',num2str(m),'}','_{n= ',num2str(n),'} (ungerade)'])
            %             colorbar
            %             colormap winter;
            %             shading interp;
        end
    end
end

% sizeIm = 1024;
spacing = linspace(1,1024,size(Z,1));
[X, Y] = meshgrid(spacing);
spacingq = linspace(1,1024,sizeIm);
[Xq, Yq] = meshgrid(spacingq);

Vq = interp2(X,Y,Z,Xq,Yq,'linear');
% imagesc(Vq)
Vq(isnan(Vq)) = 0;
end

function [R_out] = R(rho,n,m)
R_out = 0;
m = abs(m);
for s=0:(n-m)/2
    if mod(n-m,2) == 0
        RT = (-1)^s.*factorial(n-s);
        RB = factorial(s).*factorial((n+m)/2-s).*factorial((n-m)/2-s);
        R_out_h = (RT./RB).*rho.^(n-2.*s);
    else
        R_out_h = 0;
    end
    R_out = R_out + R_out_h;
end
end