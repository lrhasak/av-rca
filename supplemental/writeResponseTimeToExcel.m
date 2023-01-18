% av_writeResponseTimeToExcel
% ----------------------------
% Lindsey + ChatGPT - January 12, 2023
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

% initialize empty array to store response bins
responseBinsData = {};

for i = 1:length(filelist)
    % print file number
    i
    % move into folder
    cd(filelist(i).folder);
    
    % load file
    in = load(filelist(i).name);
    
    % extract path of file
    [fullPath, currentFolder, ext] = fileparts(filelist(i).folder);
    
    % extract parent file to get participant id
    [parentPath, parentFolder, ~] = fileparts(fullPath);
    participantID = extractAfter(parentFolder, '_');

    % extract response
    currResponse = in.R.responseBinSec;
    
    % extract condition and trial number from file name
    [~, fileName, ~] = fileparts(filelist(i).name);
    tokens = strsplit(fileName, '_');
    condition = tokens{2};
    trialNumber = tokens{3};
    
    % concatenate response, condition, and trial number in a cell array
    currResponse = {participantID, currResponse, condition, trialNumber};
    
    % Append the current responses to the cell array
    responseBinsData = [responseBinsData; currResponse];
end

% make the table
responseBinsData = cell2table(responseBinsData);
responseBinsData.Properties.VariableNames = {'part_id', 'response', 'condition', 'trial'};

% write to excel
writetable(responseBinsData,'concatenatedResponses.xlsx');





