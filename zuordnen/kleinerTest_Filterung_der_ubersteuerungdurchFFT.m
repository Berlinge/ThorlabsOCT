

test =  ((fft(mean(mag_pca(101:150,:),1))));

for i=1:1024
    test2(i,:) = (ifft((fft(mag_pca(i,:))-test)));
end

figure
imagesc(test2)
colormap gray
axis equal tight