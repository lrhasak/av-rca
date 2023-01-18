% extract p-values to csv files

out = rcaResult;
out = rcaExtra_runStatsAnalysis(out, []);

% out.sig =  harmonic (5 rows) x component (6 columns)

fileName = 'nf1_c4_pVals';
str = sprintf(fileName);
csvname = append(str,'.csv');
csvwrite(csvname, out.pValues);


% for multiple conditions trained together
for nComp = 2%1:2
   for nCon = 3 %1:3
    nf2_4710_pvals = squeeze(out.pValues(:,nComp,nCon));
    fileName = 'nf1_4710_022321_%s%d%s%d';
    A = 'comp';
    B = nComp ;
    C = 'cond';
    D = nCon;
    str = sprintf(fileName,A,B,C,D);
    csvname = append(str,'.csv');
    csvwrite(csvname, nf2_4710_pvals);
    end
end


% read and combine csv files

myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'*.csv'));
fileNames = {myFiles.name};
for k = 1:numel(myFiles)
    data{k} = csvread(fileNames{k});
    
end
allCsv = [data{1}, data{2}, data{3}, data{4}, data{5}, data{6}];

csvwrite('nf2_4710_pvals.csv',allCsv);