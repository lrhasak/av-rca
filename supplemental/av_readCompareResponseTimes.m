% av_readCompareResponseTimes
% ----------------------------
% Lindsey + ChatGPT - January 13, 2023


clear all; close all; clc

% navigate to directory where responseBin .mat files are saved
mainDir = '/Volumes/Seagate Backup Plus Drive/2020_Studies/2020_AV_RCA/Old/Exports_no21/';

% find all files
filelist = dir(fullfile(mainDir, '**/responseBins*.mat'));

%%
T = readtable('filename.xlsx');
%or 
T = readtable('filename.xlsx', 'Sheet', 'Sheet1');

%or
data = xlsread('filename.xlsx');

%Please note that xlsread reads only the numeric data from the sheet,
%if you want to read the non-numeric data like strings, dates and 
%formulas you should use readtable function.



