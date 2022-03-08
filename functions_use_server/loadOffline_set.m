% Easy offline loader - no need for main_gui.m
% Input: inf.mat file of the dataset
% path = 'D:\2019-12-19\';
% file = '\20191219_Zunge_0028_Mode2D_inf.mat';
% close all;
clearvars;
[file,path] = uigetfile('MultiSelect','on');
Set{1,1} = 'FileName';
Set{1,2} = 'RawData';
for i=1:size(file,2)
    [Raw,inf,~] = load_to_memory(path,file{1,i},dbstack);
    Set{i+1,1} = file{1,i};
    Set{i+1,2} = inf;
    Set{i+1,3} = Raw;
end