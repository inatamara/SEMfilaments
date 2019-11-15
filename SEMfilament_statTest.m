% this Matlab script loads filament width vector 'dataWidth' from different
% data files (corresponding to different experimental groups) to perform
% multiple group comparison using Kruskal-Wallis test
% For more details check Haas et al., 'Pectin homogalacturonan nanofilament
% expansion drives morphogenesis in plant epidermal cells'
%% load the data from different experimental groups
% adjust number of groups to your data
filedat = {'filename_group1',...
'filename_group2',...
'filename_group3',...
'filename_group4',...
'filename_group5'};
ngr = numel(filedat); % number of experimental groups
legendlab = {'A group 1','B group 2','C group 3','D group 4','E group 5'};
group = [];
datboxplot = [];

for i = 1:ngr
    load(filedat{i},'dataWidth') % for each group load only 'dataWidth' variable
    nigr = numel(dataWidth);  
    datboxplot = [datboxplot;dataWidth]; 
    group = [group;repmat({legendlab{i}}, nigr, 1)]; 
end
%
kw = 1; % perform kruskal-wallis test
if kw
[pvals,tbl,stats] = kruskalwallis(datboxplot,group,'off');
figure
% chose p-value adjustment method
padj = 'bonferroni'; % bonferroni p-value adjustment
% padj = 'tukey-kramer'; % tukey-kramer p-value adjustment
[cvals,estav,~,gnames] = multcompare(stats,'CType',padj );

kwtabl = [gnames(cvals(:,1)), gnames(cvals(:,2)), num2cell(cvals(:,3:6))]
end
 %% create output data in the form acceptable my R func multicomp
 sv = 1;
if sv
T = table(group,datboxplot);
dataname = strcat('StatTest','_wallwidth_','.dat');
writetable(T,dataname,'WriteRowNames',false,'Delimiter','\t') 
end