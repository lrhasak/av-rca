% av_writeResponseTimeToExcel
% ----------------------------
% Lindsey - June 21, 2022
% April 2022 note from computeSaveResponseBins: files are now saved in
% seagate/old/exports and they're written out with
% responseBins in fnOut. So I'll need to run this again with the new data
% but otherwise I can navigate to these as test files as I try to get the
% other function(s) working. 

clear all; close all; clc

% navigate to directory where responseBin .mat files are saved
mainDir = '/Volumes/Seagate Backup Plus Drive/2020_Studies/2020_AV_RCA/Old/Exports_no21/';

% find all files
filelist = dir(fullfile(mainDir, '**/responseBins*.mat'));

%% Find participants
% create participant list 
participantIDPrefix = "ENI";

participantDataArray = [];

% gets all participants in directory whose folder names start with prefix
if exist("participantIDPrefix")
    participantFolders = dir(mainDir + participantIDPrefix + "*"); 
    participantIDs = string({participantFolders.name}); 
end

%% Write Out Sheet

% load files and save out new Excel sheet file with concatenated responses
for i = 1:10 %length(filelist)
    i
    % move into folder
    cd(filelist(i).folder);
    % load file
    in = load(filelist(i).name);
    currResponse(j) = in.R.responseBinSec(j); %this assumes always 2 responses
    %T = table(pa
end

%     fnOut = ['responseBins' filelist(i).name(4:end)];
%     save(fnOut, 'R');
%     clear in R fnOut;
% %%end

% run RCA on response bins removed files
% for every participant, trial, and condition - write out as table instead
% of as file