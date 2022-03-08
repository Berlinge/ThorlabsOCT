function [output] = octf(input)
output = log(abs(fftshift(fft2(squeeze(input)))));
end

