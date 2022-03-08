function [] = display_phase_map(input)

% define phase colormap
hmap(1:256,1) = linspace(0,1,256);
hmap(:,[2 3]) = 0.7; %brightness
huemap = hsv2rgb(hmap);

if length(size(input))==2
    figure(1), clf(1)
    imagesc(input)
    %axis equal tight
    colormap(huemap)
    colorbar
    caxis([-2*pi 2*pi])
    title('Phasemap')
elseif length(size(input))==3
    h = implay(input);
    h.Visual.ColorMap.UserRange = 1;
    h.Visual.ColorMap.UserRangeMin = -pi;
    h.Visual.ColorMap.UserRangeMax = pi;
    %h.Visual.ColorMap.MapExpression = char('Phasemap [-2pi 2p]');
    h.Visual.ColorMap.Map = huemap;
else
    disp('Wrong dimensional input')
end
end

