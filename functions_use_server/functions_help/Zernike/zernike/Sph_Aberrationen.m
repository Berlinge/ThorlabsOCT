function[uout ]= Sph_Aberrationen(uin ,L,k,Wsph ,Wxp)
%Sph_Aberrationen Simuliert den Einfluss von Sph -Aberrationen

% Übergabe Werte
% uin - Eingangswellenfeld
% L - Seitenlänge(um)
% k - Kreiswellenzahl
% Wsph - Wellenfrontfehler (um)
% Wxp - Normierungsradius
% uout - Ausgangswellenfeld

% Abrufen von Übergabewerten
[M,N]= size(uin);
dx=L/M;
x=-L/2:dx:L/2-dx;
[X,Y]= meshgrid(x,x);

%Implementierung der Aberrationen
uout=uin .* exp(-j*k*Wsph *((X/Wxp ).^2+(Y/Wxp ).^2).^2);
end
