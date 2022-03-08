clc;
path = 'C:\Users\CBBM-OCM\Desktop\20161201_Drosophila\';
k = 100;
clearvars Vol
Vol = zeros(1024,1024,1024,'complex');
for y=1:1024
    load([path,'20161201_Drosophila_',num2str(k)]);
    Vol(:,:,y) = SingleBScan;
    k = k+1
    clearvars SingleBScan
end