function odd_harmonics_AV_analysis_freq

  git_folder = '/Users/lrhasak/code/Git';
    addpath(genpath(fullfile(git_folder, 'rcaExtra')),'-end');
    addpath(genpath(fullfile(git_folder, 'rcaBase')),'-end');
    addpath(genpath(fullfile(git_folder, 'mrC')),'-end');
    addpath(genpath(fullfile(git_folder, 'svndl_code')),'-end');
    addpath(genpath(fullfile(git_folder, 'edNeuro-eeg-dev')),'-end');
    addpath(genpath('/Users/lrhasak/Volumes/Seagate Backup Plus Drive//Volumes/Seagate Backup Plus Drive/2022_AV_Final_Analysis/'))

    clear all; close all; clc
    %% Loading sensor-space data
    
    % You'll need to create 'loadExperimentInfo_ + experimentName.m file
    % that is going to contain details about your source data:
    
    % first few letters or numbers of all filenames, like nl*, BLC*, etc
    % if data exports are in subdirectory (nl*/time/RawTrials)
    % what frequencies are present in the dataset (for reverse-engineeering epoch length) 
    % see loadExperimentInfo_Lochy_Oddball.m
     
   
    clear all;
    experimentName = 'Exports_AV';
    
    % load up expriment info specified in loadExperimentInfo_experimentName
    % matlab file. Lines 21-28 are generic and can be copy-pasted  
    % analysisStruct contains info about data location and data properties
    
    try
        analysisStruct = feval(['loadExperimentInfo_' experimentName]);
    catch err
        % in case unable to load the designated file, load default file
        % (not implemented atm)
        disp('Unable to load specific expriment settings, loading default');
        analysisStruct = loadExperimentInfo_Default;
    end
    
    
    % analysisStruct.domain will be propagated to rcaSetting, stats, plotting and needs to
    % be defined for the use of any high-level function 
    analysisStruct.domain = 'freq';
    
    loadSettings_f = rcaExtra_getDataLoadingSettings(analysisStruct);
    
    % print available frequenciesfor each condition/subject
    % this excel sheet is saved in the MAT folder
    % 59 looks to be a particularly messy subject
    rcaExtra_analyzeFrequencyDataset(loadSettings_f.destDataDir_MAT);
    
    % loading: specify what frequencies and bins to load
    loadSettings_f1 = loadSettings_f;
    loadSettings_f1.useBins = 1:10; 
    loadSettings_f1.useFrequencies = {'1F1', '3F1', '5F1', '7F1','9F1'};
    
    % advanced loading:
    % loadSettings.useBins = []; will load all available bins except 0
    % loadSettings.useTrials = [] will load all available trials except 0
    % loadSettings.useBins = 0; will load average bins.
    % loadSettings.useTrials = 0 will load average trials.
    % loadSettings.useChannels = 76;
    
    % lets load average per subject per condition for channel 76
%     loadSettings_ch76_t0b0 = loadSettings_f1;
%     loadSettings_ch76_t0b0.useBins = 0;
%     loadSettings_ch76_t0b0.useTrials = 0;
%     loadSettings_ch76_t0b0.useChannels = 76;
%     [subjList, EEGData_ch76_t0b0] = getRawData(loadSettings_ch76_t0b0);
    
    % read raw data 
    [subjList, EEGData_f1, Noise1_f1, Noise2_f1, ~] = getRawData(loadSettings_f1);
    
    % reshape 2 subjects with wrong cell sizes in condition 11
    % subject 1
%     EEGData_f1{2, 11} = EEGData_f1{2, 11}(:, :, 1:10);
%     Noise1_f1{2, 11} = Noise1_f1{2, 11}(:, :, 1:10);
%     Noise2_f1{2, 11} = Noise2_f1{2, 11}(:, :, 1:10);
%         
%     % subject 2    
%     EEGData_f1{5, 11} = EEGData_f1{5, 11}(:, :, 1:10);
%     Noise1_f1{5, 11} = Noise1_f1{5, 11}(:, :, 1:10);
%     Noise2_f1{5, 11} = Noise2_f1{5, 11}(:, :, 1:10);

    
    %% RCA 
    % get generic template for RCA settings
    rcSettings = rcaExtra_getRCARunSettings(analysisStruct);
    
    %Filling out the template with subjects list:
    rcSettings.subjList = subjList;
        
    %copy settings template to 2hz analysis template 
    runSettings__nF1 = rcSettings;
    
    % use all bins
    runSettings__nF1.useBins = loadSettings_f1.useBins;
    
    % use all harmonics
    runSettings__nF1.useFrequencies = {'1F1', '3F1', '5F1','7F1','9F1'};
    % the name under which RCA result will be saved inyour output/RCA directory
    
    runSettings__nF1.label = 'c24_nF1';
    runSettings__nF1.computeStats = 1;
    runSettings__nF1.useCnds = [2, 4];
  

    rcResult_c24_nF1 = rcaExtra_runAnalysis(runSettings__nF1, EEGData_f1, Noise1_f1, Noise2_f1);
    %% re-binning    
    % re-bin the data and run the analysis again using 1 bin in settings:
    nFreqs = length(loadSettings_f1.useFrequencies);

    EEGData_f1_1bin = cellfun(@(x) rcaExtra_reshapeBinsToTrials(x, nFreqs),...
        EEGData_f1, 'UniformOutput', false);
    noise_LO_f1_1bin = cellfun(@(x) rcaExtra_reshapeBinsToTrials(x, nFreqs),...
        Noise1_f1, 'UniformOutput', false);
    noise_HI_f1_1bin = cellfun(@(x) rcaExtra_reshapeBinsToTrials(x, nFreqs),...
        Noise2_f1, 'UniformOutput', false);
    
    runSettings__nF1_1bin = runSettings__nF1;
    runSettings__nF1_1bin.useBins = 1;
    runSettings__nF1_1bin.label = 'Condition%c_nF1_1bin';

    rcResult_c24_nF1_1bin = rcaExtra_runAnalysis(runSettings__nF1_1bin, EEGData_f1_1bin, noise_LO_f1_1bin, noise_HI_f1_1bin);
    
    
    %%  Weight Flipping (match with xDiva waveform polarity)
    
    % function will use command line prompt:
    % do you want to save the results? 
    % (Y) Do you want to save results as new matfile?
    % Vector specifies both desired order and polarity: [-1 2 3 4 5 6]
    % To change order [-2 1 3 4 5 6]
    
    % all bins
    rcResult_c24_nF1_clean = rcaExtra_adjustRCWeights(rcResult_c24_nF1, [-1 2 -3 -4 -5 -6]);
   
    % 1 bin 
   %rcResult_c2_nF1_1bin
   rcResult_c24_nF1_1bin_flipped = rcaExtra_adjustRCWeights(rcResult_c24_nF1_1bin, [-1 -2 -3 4 5 6]);
   
    
    
    %% Run RCA on merged conditions 
    
%     % merging two conditions (same, but add noise1, noise 2)
%     data_nF1_clean_c12 = rcaExtra_mergeDatasetConditions(data_nF1, [1, 2]);
%     runSettings_2hz_c12_nF1clean = runSettings_c1234_2hz_nF1clean;
%     runSettings_2hz_c12_nF1clean.label = 'Conditions_1-2_nF1_clean';
%     runSettings_2hz_c12_nF1clean.useCnds = 1;
%     rcResult_2hz_c12_nF1clean = rcaExtra_runAnalysis(runSettings_2hz_c12_nF1clean, data_nF1_clean_c12);
%      
%     %% Project through learned weights
%     % projecting conditions 3, 4 through weights learned on combined [1, 2]
%     
%     [projected_c3_nF1_clean, projected_c4_nF1_clean] = ...
%         rcaExtra_projectDataSubset(rcResult_2hz_c12_nF1clean, data_nF1(:, 3), data_nF1(:, 4));
%     
    
    %% Plot
    % package with colors, make sure to have enough for each condition
    load('colorbrewer');
    % Rows = colors, columns = RGB values in 1-255 range (need to be normalized by /255) 
    colors_to_use = colorbrewer.qual.Paired{6};
        
    %% plotting all rcResult_nF1_1bin
    rcResult_c24_nF1_1bin.rcaSettings.computeStats = 1;

    plot_nF1_1bin = rcaExtra_initPlottingContainer(rcResult_c24_nF1_1bin_flipped);
    plot_nF1_1bin.conditionLabels = analysisStruct.info.conditionLabels;
    plot_nF1_1bin.rcsToPlot = 1:4;
    plot_nF1_1bin.cndsToPlot = arrayfun(@(x)...
                                        find(rcResult_c24_nF1_1bin_flipped.rcaSettings.useCnds...
                                        == x), rcResult_c24_nF1_1bin_flipped.rcaSettings.useCnds);
    plot_nF1_1bin.conditionColors = colors_to_use./255;
    
    % plots groups, each condition in separate window
    
    % amps are currently pretty useless
    rcaExtra_plotAmplitudes(plot_nF1_1bin);
    rcaExtra_plotLollipops(plot_nF1_1bin);
    % error happening with plotLatencies (mismatch in axes?)
    rcaExtra_plotLatencies(plot_nF1_1bin);

    % split conditions, plot separately
  %  [c1_rc, c2_rc, c3_rc, c4_rc, c5_rc, c6_rc, c7_rc, c8_rc, c9_rc, c10_rc, c_11_rc]  = rcaExtra_splitPlotDataByCondition(plot_nF1_1bin);
    [c2, c4]  = rcaExtra_splitPlotDataByCondition(plot_nF1_1bin);
    %%  plot separate conditions
    % this is actually plotting different conditions together!  
    rcaExtra_plotAmplitudes(c2, c4);
    rcaExtra_plotLollipops(c2, c4);
    rcaExtra_plotLatencies(c2, c4);
    
    
    % let's do 2, 7, 10, and 2/4
    rcaExtra_plotAmplitudes(c2_rc, c7_rc, c10_rc);
    rcaExtra_plotAmplitudes(c2_rc, c4_rc);
    rcaExtra_plotLollipops(c1_rc, c2_rc, c3_rc, c4_rc);
    rcaExtra_plotLatencies(c2_rc, c7_rc, c10_rc);
    %% split rcResults
    rc_1 = rcaExtra_selectConditionsSubset(rcResult_c24_nF1_1bin_flipped, 1);
    rc_2 = rcaExtra_selectConditionsSubset(rcResult_c24_nF1_1bin_flipped, 2);    
    rc_3 = rcaExtra_selectConditionsSubset(rcResult_c24_nF1_1bin, 1);
    rc_4 = rcaExtra_selectConditionsSubset(rcResult_c24_nF1_1bin, 2);    

    %% Stats
    
    rcaExtra_plotAmplitudeWithStats(c2, c4, rc_1, rc_2)
    % let's add stats computing 
    c24_stats = rcaExtra_runStatsAnalysis(rc_1, rc_2, 1);
    
    % specify plotting
    %% Compare Topo Maps?
    rcaExtra_compareTopoMaps(rcResult_c24_nF1_1bin_flipped.A);

end