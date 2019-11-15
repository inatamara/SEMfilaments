% This Matlab script combines the data from different files corresponding
% to the same experimental group (e.g. WT). You will probably need it if
% you use SEMfilamentCSV to load single experiment at a time
% For more details check Haas et al., 'Pectin homogalacturonan nanofilament
% expansion drives morphogenesis in plant epidermal cells'
%% chose files from the list
clear all
clc
close all

% select file from the list
filelist = dir('*.mat');
fnames = {filelist(:).name}'; 
str = {fnames{:}}';
s = listdlg('PromptString','Select files:',...
                'SelectionMode','multiple',...
                'ListString',str); % chose only some timelapse point you want to analyse
files = str(s);
nf = numel(files);
%% WT str
dataWT_WIDTH_str = [];
dataWT_INTER_str = [];
for fi = 1:nf
    load(files{fi},'dataWidth','dataInterspace')
    dataWT_WIDTH_str =[dataWT_WIDTH_str;dataWidth];
    dataWT_INTER_str =[dataWT_INTER_str;dataInterspace];
end

dataWidth = dataWT_WIDTH_str;
dataInterspace = dataWT_INTER_str;
uisave('myPooledData.mat',{'dataWidth','dataWT_INTER_str'})