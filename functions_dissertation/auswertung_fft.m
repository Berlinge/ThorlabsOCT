load('E:\OneDrive\Dissertation\Daten\2019-11-19 Zunge 28 Phasenkorrigiert mit Alg.mat')
%%
input = abs(Raw(1:1024,:,:));
input = abs(input(:,:,:));
input = fft(input,size(input,3),3);
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

imagesc(cat(3,r,g,b))
axis equal tight

%%
