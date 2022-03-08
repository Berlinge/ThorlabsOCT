function [x,y] = detect_center(image)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[~,x] = max(movmean(mean(log(abs(image)+1),2),5));
max(x)
[~,y] = max(movmean(mean(log(abs(image)+1),1),5));

% imagesc(log(abs(image)))
% hold on
% plot(x,y,'rx');
end

