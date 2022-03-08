    % Easy offline loader - no need for main_gui.m
% Input: inf.mat file of the dataset
% path = 'D:\2019-12-19\';
% file = '\20191219_Zunge_0028_Mode2D_inf.mat';
% close all;
clearvars;
[file,path] = uigetfile;
[Raw,inf,~] = load_to_memory(path,file,dbstack);