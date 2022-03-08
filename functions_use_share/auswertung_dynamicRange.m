figure(1)
clf(1)
for ii = 2:size(Set,1)
    Raw = Set{ii,4};
    for i=1:1 %size(Raw,3)
        plot(octa(mean(squeeze(abs(Raw(:,1:20,i))),2)))
        hold on
    end
end
ylim([-40 80])
% Gaussian gitt on first measurement

% FWHM and axial resolution calc
