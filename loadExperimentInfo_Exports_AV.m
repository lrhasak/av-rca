function adultsAVInfo = loadExperimentInfo_Exports_AV
    
    %% info is a structure describing experiment parameters
    adultsAVInfo = rcaExtra_genStructureTemplate;
    [curr_path, ~, ~] = fileparts(mfilename('fullpath'));
    adultsAVInfo.path.rootFolder = curr_path;
    
    % source EEG data
    srcDirPath = uigetdir(curr_path, 'Select EEG SOURCE directory');
    if (~isempty(srcDirPath))
        adultsAVInfo.path.sourceEEGDir = srcDirPath;
    end
        
    % destination EEG directory
    adultsAVInfo.path.destDataDir = uigetdir(curr_path, 'Select analysis results directory');
    

    %% create subdirectories
    dirNames = {'MAT', 'FIG', 'RCA'};
    dirPaths = rcaExtra_setupDestDir(adultsAVInfo.path.destDataDir, dirNames);
    
    adultsAVInfo.path.destDataDir_MAT = dirPaths{1};
    adultsAVInfo.path.destDataDir_FIG = dirPaths{2};
    adultsAVInfo.path.destDataDir_RCA = dirPaths{3};
   
    % replace default values here
    adultsAVInfo.info.subjTag = '*';
    adultsAVInfo.info.subDirTxt = 'text';
    adultsAVInfo.info.subDirMat = 'matlab';
    adultsAVInfo.info.groupLabels = {'Adult AV'};
    adultsAVInfo.info.conditionLabels = {'Condition 1', 'Condition 2', 'Condition 3', 'Condition 4', 'Condition 5'...
        'Condition 6', 'Condition 7', 'Condition 8', 'Condition 9', 'Condition 10', 'Condition 11'};
    adultsAVInfo.info.frequenciesHz = [1, 2];
    adultsAVInfo.info.useSpecialDataLoader = false;
    adultsAVInfo.info.frequencyLabels = {{'1F1' '2F1' '3F1' '4F1', '5F1', '6F1', '7F1', '8F1', '9F1'}};
    adultsAVInfo.info.binsNmb = 10;
end



