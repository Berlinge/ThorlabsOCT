for i=2:31
    Set{i,5} = std(Set{i,4},0,3);
end
%%
clearvars erg
k = 1;
for i=2:3:31
    i1 = Set{i:i,5};
    i2 = Set{i:i+1,5};
    i3 = Set{i:i+2,5};
    
    erg(:,:,k) = (i1+i2+i3)/3;
    k = k+1;
end