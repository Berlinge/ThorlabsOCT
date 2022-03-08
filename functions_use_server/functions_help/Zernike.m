function [Z] = Zernike(m,n)
%zernike

x = linspace(-1,1,1024);
[X,Y] = meshgrid(x,x);
[phi,rho] = cart2pol(X,Y);

s = (n-m)/2;

if ( s == floor(s) )
    if ( (n-s) == floor(n-s) )
        if m>=0
            F = @(rho,phi,m,n)  R(rho,n,m) .* cos(m .* phi);
            Z = F(rho,phi,m,n);
            Z(rho>1) = 0;            
        elseif m<0
            F = @(rho,phi,m,n)  R(rho,n,m) .* sin(m .* phi);
            Z = F(rho,phi,m,n);
            Z(rho>1) = 0;  
        end

    end
end
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