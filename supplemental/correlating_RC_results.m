%% Correlating A between conditions
% This script takes RCA results and correlates the topographies (A).

clear all; close all; clc
%% find and load data
datalocation_2019 = '/Users/lrhasak/code/Git/2022_AV_Analysis/2019_sessions_RCA/';
datalocation_2022 = '/Users/lrhasak/code/Git/2022_AV_Analysis/';
datalocation_combo = '/Users/lrhasak/code/Git/2022_AV_Analysis/combined_RCA/';

% load 2019 data
load(strcat(datalocation_2019, 'RCA/rcaResults_Freq_Alt Visual 1-back.mat'));
c2019_A = rcaResult.A;

% load 2022 data
load(strcat(datalocation_2022,'2022_sessions_RCA/even/RCA/rcaResults_Freq_Condition_c2_nF2.mat'));
c2022_A = rcaResult.A;

% load combined data 
load(strcat(datalocation_combo,'RCA/rcaResults_Freq_Combined_Alt_Vis_1-back.mat'));
combo_A = rcaResult.A;

% create component vectors
    comp_1 = [c2019_A(:, 1), c2022_A(:, 1), combo_A(:, 1)];
    comp_2 = [c2019_A(:, 2), c2022_A(:, 2), combo_A(:, 2)];
    comp_3 = [c2019_A(:, 3), c2022_A(:, 3), combo_A(:, 3)];
    comp_4 = [c2(:, 4), c7(:, 4), c10(:, 4)];
    

% plot correlations
comps = {comp_1, comp_2, comp_3};
titles = {'Condition 2 RC 1 Correlations', 'Condition 2 RC 2 Correlations', 'Condition 2 RC 3 Correlations'};

for i = 1:numel(comps)
    figure;
    [rho,pvalue,H] = corrplot(comps{i}, 'varNames', {'2019', '2022', 'combo'}); % need to download Econometrics Toolbox
    t = tril(rho, -1) > 0;
    mirrors = find(t == 1);
    for j=1:size(mirrors)
        delete(subplot(3,3,mirrors(j)));    
    end
    title(titles{i});
end



%% PROGRESS
   
   % this actually does work
   nComp = 6
   for a = 1:nComp
       comp{a} = [c2(:, nComp), c7(:, nComp), c10(:, nComp)];
   end   
    
