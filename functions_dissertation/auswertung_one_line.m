fenface = fftshift(fft(enface,100,3),3);

input = ifftshift(fenface,3);
input = input(1:size(input,1),:,:);

testb = sum(abs(input(:,:,1:1)),3);
testg = sum(abs(input(:,:,1:8)),3);
testr = sum(abs(input(:,:,1:36)),3);

b = testb;
g = testg-testb;
r = testr-testg;
r = r-min(r(:));
g = g-min(g(:));
b = b-min(b(:));
r = r./max(r(:));
g = g./max(g(:));
b = b./max(b(:));
r = log(r./max(r(:))+1);
g = log(g./max(g(:))+1);
b = log(b./max(b(:))+1);
r = medfilt2(r);
g = medfilt2(g);
b = medfilt2(b);
r = r-min(r(:));
g = g-min(g(:));
b = b-min(b(:));
r = r./max(r(:));
g = g./max(g(:));
b = b./max(b(:));
output = cat(3,r,g,b);   

x = 340;

clc;

figure(1), clf(1)
imagesc(log(std(enface,0,3))),
colormap gray
axis equal tight
hold on
line([1,550],[x,x]),
hold off

figure(2), clf(2)
lin = squeeze(mean(enface(x-2:x+2,:,:),1));
plot(movmean(log(squeeze(std(lin,0,2))),5))
axis tight

figure(3), clf(3)
image = log(abs(squeeze(mean(fenface(x-2:x+2,:,:),1))))';
imagesc(movmean(medfilt2(image(1:48,:),[3 1]),[1 2],1))

figure(4), clf(4)
image = log(abs(squeeze(mean(enface(x-2:x+2,:,:),1))))';
imagesc(movmean(medfilt2(image(1:48,:),[1 1]),[1 1],1))

figure(5), clf(5)
imagesc(output)
axis equal tight
hold on
line([1,550],[x,x]),
hold off

%%
clearvars image r g b
image = ifftshift((abs(squeeze(mean(fenface(x-2:x+2,:,:),1))))',1);
imagesc(image)

bb = sum(abs(image(1:1,:)),1);
gg = sum(abs(image(1:8,:)),1);
rr = sum(abs(image(1:36,:)),1);
b = bb;
g = gg-bb;
r = rr-gg;
rrr = log(r+1);
ggg = log(g+1);
bbb = log(b+1);
r = r-min(r(:));
g = g-min(g(:));
b = b-min(b(:));
r = r./max(r(:));
g = g./max(g(:));
b = b./max(b(:));
r = log(r./max(r(:))+1);
g = log(g./max(g(:))+1);
b = log(b./max(b(:))+1);
r = medfilt1(r);
g = medfilt1(g);
b = medfilt1(b);
r = r-min(r(:));
g = g-min(g(:));
b = b-min(b(:));
r = r./max(r(:));
g = g./max(g(:));
b = b./max(b(:));

rgb = zeros(3,550,3);
rgb(1,:,1) = r;
rgb(2,:,2) = g;
rgb(3,:,3) = b;

figure(6), clf(6)
imagesc(rgb)
% r = padarray(r,'pre');
% % g = padarray(g,0,'post');
% b = padarray(b,0,'post');

rgb2 = zeros(1,550,3);
rgb2(1,:,1) = r;
rgb2(1,:,2) = g;
rgb2(1,:,3) = b;

figure(7), clf(7)
test2 = medfilt3(rgb2,[1 3 1]);
imagesc(test2)

figure(8), clf(8)
test = output(340,:,:);
imagesc(test)

figure(9), clf(9)
plot(rrr,'r'); hold on; plot(ggg,'g'); plot(bbb,'b');
xlim([1 550])