function [ apoVector ] = ApoVector( refSpectrum, BtECS )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
ElectronFloor = BtECS;
Z = size(refSpectrum,1);
minElectron = min(refSpectrum);
ElectronFloor = ElectronFloor + minElectron;
a=max([find(refSpectrum>ElectronFloor,1,'first'),Z -  find(refSpectrum > ElectronFloor,1,'last')]);
% Window=vertcat((zeros(a,1)),hann(Z-2*a),(zeros((Z)-(Z-a),1)));
Window=vertcat((zeros(a,1)),tukeywin(Z-2*a,0.75),(zeros((Z)-(Z-a),1))); 
apoVector = max(max(refSpectrum)) * Window ./ (refSpectrum);
%  apoVector = Window ./ (Spectrum);
%  apoVector = 1 ./ (Spectrum);
apoVector(isnan(apoVector)) = 0;
apoVector(isinf(apoVector)) = 0;
end

