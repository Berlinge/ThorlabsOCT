function [ Dispersion ] = DispVector(dispCoeff, Chirp, b_scan_width)
w = (Chirp-Chirp(length(Chirp)/2))./length(Chirp);
Dispersion = polyval([flip(dispCoeff) 0 0 ],w);
Dispersion = repmat(Dispersion,1,b_scan_width);
Dispersion = exp(-1i.*Dispersion);
end

