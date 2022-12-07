function[uout ]= Ideallens(uin ,L,k,zf)
%IdealLens Simuliert eine ideale Fokussierung

% Übergabe Werte
% uin - Eingangswellenfeld
% L - Seitenlänge(um)
% k - Kreiswellenzahl
% zf - Brennweite (um)
% uout - Ausgangswellenfeld

% Abrufen von Übergabewerten
[M,N]= size(uin); dx=L/M;
x=-L/2:dx:L/2-dx;

[X,Y]= meshgrid(x,x);

%Implementierung des Phasenfaktors
uout=uin.*exp(-j*k*sqrt(zf^2+X.^2+Y.^2));
end