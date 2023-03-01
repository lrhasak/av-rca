% av_computeSaveResponseBins.m 
% ----------------------------
% Blair and Lindsey - July 17, 2020
% April 2022 note: files are now saved in seagate/old/exports and they're written out with
% responseBins in fnOut. So I'll need to run this again with the new data
% but otherwise I can navigate to these as test files as I try to get the
% other function(s) working. 

clear all; close all; clc

% navigate to directory where raw .mat files are saved
mainDir = '/Volumes/Seagate Backup Plus Drive/2023_MS_AVWord/2023_Sessions/';

% find all files
filelist = dir(fullfile(mainDir, '**/**/**/Raw*.mat'));

% load files, run detectResponseBins function, and save out new file with
% response bins removed
for i = 1:length(filelist)
    i
    % move into folder
    cd(filelist(i).folder);
    % load file
    in = load(filelist(i).name);
    R = detectResponseBins(in.RawTrial);
    fnOut = ['responseBins' filelist(i).name(4:end)];
    save(fnOut, 'R');
    clear in R fnOut;
end

% run RCA on response bins removed files
% for every participant, trial, and condition - write out as table instead
% of as file