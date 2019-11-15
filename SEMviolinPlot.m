% this Matlab script loads filament width vector 'dataWidth' from different
% data files (corresponding to different experimental groups) and plot it
% using violin plot (violonkd)
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
dataviolin = cell(ngr,1);
for i = 1:ngr
    load(filedat{i},'dataWidth') % for each group load only 'dataWidth' variable
    dataviolin{i} = dataWidth;% for the violin plot
end
%% figure properties
width = 2.5;% Width in inches
height = 3; %height in inches
alw=1.5;% AxesLineWidth
fsz=10; % Fontsize
lw=2;%  % LineWidth
msz=15; % MarkerSize
fszl=8; % Fontsize legend
fontname='Helvetica'; % Fontsize name
tickdir = 'out';
ticksize= [0.02 0.035]; % Fontsize legend
figname = 'saveing name of your fig here';
mc = [33,30,40]/255;
medc = mc;
fcol = [166,171,171]/255;
fcoledge = [166,171,171]/255;
xlab = [];

xtixklab = legendlab;
bw = [];
grpos = 1:numel(legendlab);
scaleFactor = 0.1;
ngr = numel(legendlab);
normfac = 0.45;

[~,~,l1,~,~,~,~,med,avg] = violonkd(datviolin,bw,normfac,grpos,fcol,fcoledge,mc,medc,0.75,...
width,height,alw,fsz,lw,fszl,fontname,xlab,ylab,xtixklab);
hold on
colp = [242, 154, 46]/255;
for ii = 1:ngr
nd = numel(datviolin{ii});

x = grpos(ii) + scaleFactor * randn(nd,1);
plot(x,datviolin{ii},'.','Color',colp,'MarkerSize',8)
end
% plot(grpos,avg,':','MarkerSize',msz,'Color',mc)
plot(grpos,med,'.','MarkerSize',msz,'Color',medc)

ylim(ylim1);
xlim(gca,[grpos(1)-normfac,grpos(end)+normfac])
tl = title('Title here');
set(tl,'Fontname',fontname, 'Fontsize', fsz,'color','k')  
set(gca,'TickDir', tickdir);
set(gca,'TickLength', ticksize); 
set(gca,'XTickLabelRotation',45)
set(l1,'visible','off');
savefig(figname)