function [ s ] = spectral_density( lvector , kvector , l0 , FWHM )

%Spektrale Leistungsdichte
s = normpdf(lvector,l0,FWHM/2.4583);
s = s - s(1);
s = interp1(lvector,s,2*pi./kvector );
s = s/max(s);
s(1) = 0.0001;
figure (1); plot(s);
end