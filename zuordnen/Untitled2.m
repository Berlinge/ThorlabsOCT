clc; clf(1)
image = (Raw_n2(1:1024,:,2));
% imagesc(image)
% axis equal tight

k = 1;
image_new = complex(zeros(1024,500));
for i=1:500
    diff = Raw_n2(1:1024,:,i).*conj(Raw_n2(1:1024,:,i+1));
    image_new = image_new+((diff+pi));
    k = k+1;
    imagesc(angle(image_new))
    axis equal tight
    colorbar
    pause(0.1)
end
% colormap gray