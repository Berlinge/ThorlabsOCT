path  = uigetdir();
%%
clc
I = imread([path,'/l0400.tif']);
[~,I] = function_color_segementation_liver(I);
imagesc(I)
axis equal tight
