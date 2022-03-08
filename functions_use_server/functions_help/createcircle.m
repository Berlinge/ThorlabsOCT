[X,Y] = meshgrid(-255:256,-255:256);
test = linspace(-1,1,256);
test = [test fliplr(test)];
for i=1:512
    testi(i,:) = test; 
end
testi(sqrt(X.^2+Y.^2)>255) = 0;
figure
imagesc(testi)

