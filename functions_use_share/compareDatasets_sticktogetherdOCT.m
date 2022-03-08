clearvars S
for i=2:size(Set,1)
    S(:,:,:,i-1) = Set{i,6};
end
%%
for i=1:3
    d = log(S(:,:,i,:)+1);
    d = d-min(d(:));
    d = d./max(d(:));
    S(:,:,i,:) = d;
end
%%
implay(permute(S,[2 4 3 1]))
implay(S)
%%
output = S;
options.color     = true;
options.compress  = 'no';
options.message   = true;
options.append    = false;
options.overwrite = true;
options.big       = true;
outputpath = uigetdir;
res = saveTiffStack(permute(output(:,:,:,:),[1 2 3 4]),[outputpath,'\output.tif'], options);