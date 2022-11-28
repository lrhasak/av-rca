%% Correlating A between conditions
% TThis script takes RCA results and correlates the topographies (A).
%% find and load data
  datalocation = '/Volumes/Seagate Backup Plus Drive/2020_Studies/2020_AV_RCA/2021_QP_redo/';
    load(strcat(datalocation,'RCA/rcaResults_Freq_Condition 4.mat'))
    alternating_A = rcaResult.A;
    
  % attempt - consider this fake data
dude = rc_1.A;
    
%     load(strcat(datalocation,'RCA/rcaResult_Freq_c10_flipped.mat'))
%     incongruent_A = rcaResult.A;
%     
%     load(strcat(datalocation,'RCA/rcaResults_Freq_Condition 7.mat'))
%     congruent_A = rcaResult.A;
    
   % load(strcat(datalocation,'RCA/rcaResult_Freq_rcaResult_c3_nf2_flipped.mat'))
   % audio_A = rcaResult.A
 
    % 128 x 18: electrode x 6 components x 3 structs
    A = [alternating_A, congruent_A, incongruent_A];
    comp_1 = [alternating_A(:, 1), congruent_A(:, 1), incongruent_A(:, 1)];
    comp_2 = [alternating_A(:, 2), congruent_A(:, 2), incongruent_A(:, 2)];
    
    A = [alternating_A, dude];
    comp_1 = [alternating_A(:, 1), dude(:, 1)];
    
    % fake data shows a 98% correlation lol guess that makes sense though
    figure;
    [rho,pvalue,H] = corrplot(comp_1, 'varNames', {'old', 'new'})
    
   
%    alt_comp = zeros(128, 6);
%     for i = 1:size(alternating_A, 2)
%         for j = 1:length(alternating_A)
%         alt_comp(i) = alternating_A(j)
%         end
%     end
    
    figure;
    [rho,pvalue,H] = corrplot(comp_1, 'varNames', {'alt', 'con', 'incon'}) % need to download Econometrics Toolbox
    title('Component 1 Correlations')
  
    figure; 
    [rho,pvalue,H] = corrplot(comp_2, 'varNames', {'alt', 'con', 'incon'})
    title('Component 2 Correlations')
    
% %  Find the index to remove the upper triangular part alone, this might
% % be different for you base on you data but you can manually import the indexes
% % or change the conditions in tril and find
% t = tril(rho, -1) > 0;
% mirrors = find(t == 1);
%  
% % delete the unnecessary subplots
% for i=1:size(mirrors)
%     delete(subplot(3,3,mirrors(i)));    
% end
