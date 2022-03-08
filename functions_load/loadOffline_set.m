% Easy offline loader - no need for main_gui.m
% Input: inf.mat file of the dataset
% path = 'D:\2019-12-19\';
% file = '\20191219_Zunge_0028_Mode2D_inf.mat';
% close all;
clearvars;
[file,path] = uigetfile('MultiSelect','on');
Set{1,1} = 'FileName';
Set{1,2} = 'RawData'; 
k = 1;
t = 1 ; % timesteps (1 for every)
for i=1:t:size(file,2)
    [Raw,inf,~] = load_to_memory(path,file{1,i},dbstack);
    Set{k+1,1} = file{1,i};
    Set{k+1,2} = inf;
    Set{k+1,3} = Set{k+1,2}.Comment;
    Set{k+1,4} = Raw(:,:,:);
    %     Set{k,4} = dOCT_Bscan(Raw(:,:,:),0); % inline processing
    k = k+1
end