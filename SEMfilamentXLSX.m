% this script reads the data from excel file. Excel file can have multiple
% sheets - corresponding for instance to different measurements or groups.
% Each sheet can have multiple columns, however, each column musy have the
% same number of rows. If they are different, you will have to remove empty
% cells from txt cell aray or NaNs from raw cell array.
% In the first row of the one after last column for each sheet,
% put a magnification factor for the SEM picture
% for more details check Haas et al., 'Pectin homogalacturonan nanofilament
% expansion drives morphogenesis in plant epidermal cells'
clear all
clc
close all
%%
[file,path] = uigetfile('*.xlsx');
filename = fullfile(file, path);
[status,sheets] = xlsfinfo(filename); % read xlsx file
minHeight = 5; % minimum peak height
minPROM = 2;% % minimum peak prominence
pixfilt = 0; % put to 1 if you want to filter based on the pixel size
pixR = 7.2;%  pixel size of one reference picture % 200nm=0.146
LOCSdiffALL = []; % initialize filament interspace matrix
WIDTHall = []; % initialize filament width matrix
PROMall = []; % initialize filament proiminence matrix
PKSall = []; % initialize filament peak location matrix
pl = 1; % put to 1 if you want to plot findpeak function results
flag = 0;
for si = 1:numel(sheets) % loop over sheets
    
    [num,txt,raw] = xlsread(filename,si);
    ns = size(raw,2); % number of columns in xlsx sheet si
    mag = str2num(raw{1,ns}); % read the magnification of the image, 
    % you can put it to constant number if the magnification does not change
    pix(si,1) = (pixR*40)/mag; % calculate the pixel size for each image si
    a = 1;
    windowSize = floor(mag/20); 
    b = (1/windowSize)*ones(1,windowSize);
   
    for ni = 1:ns-1 % loop over different columns in si sheet(if applicable)
        flag = flag+1;
        samples{flag,1} = cell2mat(cellfun(@str2num,txt(:,ni),'UniformOutput',false));
        xsample{flag,1} = filter(b,a,[1:numel(samples{flag,1})]*pix(si,1));
        %xsample{flag,1} = [1:numel(samples{flag,1})]*pix;
        [PKS{flag,1},LOCS{flag,1},WIDTH{flag,1},PROM{flag,1}] = ...
        findpeaks(samples{flag,1},xsample{flag,1},'MinPeakHeight',minHeight,'Annotate',...
        'extents','MinPeakProminence',minPROM);
        if pixfilt % filter the data based on pixel width, all filaments with width < 2*pix will be removed
            widthni = WIDTH{flag,1};
            LOCSdiff{flag,1} = diff(LOCS{flag,1}(widthni > 2*pix(si,1)));
            LOCSdiffALL = [LOCSdiffALL;LOCSdiff{flag,1}'];
            WIDTHall = [WIDTHall,widthni(widthni > 2*pix(si,1))];
            PROMall = [PROMall;PROM{flag,1}(widthni > 2*pix(si,1))];
            PKSall = [PKSall;PKS{flag,1}(widthni > 2*pix(si,1))];
            WIDTHmed(flag,1) = median(widthni(widthni > 2*pix(si,1)));
        else % filet the data based on the constant threshold later on in the script
            LOCSdiff{flag,1} = diff(LOCS{flag,1});
            LOCSdiffALL = [LOCSdiffALL;LOCSdiff{flag,1}'];
            WIDTHall = [WIDTHall;WIDTH{flag,1}'];
            PROMall = [PROMall;PROM{flag,1}];
            PKSall = [PKSall;PKS{flag,1}];
            WIDTHmed(flag,1) = median(WIDTH{flag,1});
         end
        if pl % plot each data
            f1 = figure;
            title(sprintf('Sheet: %d ',si))
            findpeaks(samples{flag,1},xsample{flag,1},'MinPeakHeight',minHeight,'Annotate',...
            'extents','MinPeakProminence',minPROM);
            axis square
            xl = xlabel(gca,'Distance (nm)', 'Interpreter', 'none');
            set(xl,'Fontname',fontname, 'Fontsize', fsz)    
            set(gca,'Fontname',fontname,'FontSize',fsz)    
            set(gca,'box','off');   
            yl = ylabel(gca, 'Intensity (a.u.)', 'Interpreter', 'none');
            set(yl,'Fontname',fontname, 'Fontsize', fsz)  
            set(gca,'TickDir', tickdir);
            set(gca,'TickLength', ticksize); 
            set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
            set(gca,'box','off');
            pos = get(f1, 'Position');
            set(f1, 'Position', [pos(1)-100 pos(2)-100 width*80, height*80]); %<- Set size
            set(f1,'PaperUnits', 'inches');
        end
    end
end
%%

width = 3; % figure size
height = 3;
violet = [81,110,183]/255;
alp = 0.5; % transparence of the histogram plot
thrUP = 50; % upper threshold of the filament FWHM in nm here
thrDOWN = 10; % lower threshold of the filament FWHM in nm here
dataWidth = unique(WIDTHall(WIDTHall>thrDOWN & WIDTHall<thrUP)); % filter the width
disp('Filament width mean')
meanW = mean(dataWidth) % mean of the filament width
disp('Filament width median')
medianW = median(dataWidth) %median
thrINTUP = 120; % upper threshold of the filament interspacing in nm here
dataInterspace = unique(LOCSdiffALL(LOCSdiffALL>thrDOWN & LOCSdiffALL<thrINTUP)); %filter filament interspacing;
disp('Filament interspacing mean')
meanIS = mean(dataInterspace)
disp('Filament interspacing median')
medianIS = median(dataInterspace)
disp('Filament width median absolute deviation')
madW = mad(dataWidth,1)
disp('Filament interspacing median absolute deviation')
madIS = mad(dataInterspace,1)

sel = 2;
if sel == 1 % plot filament interspacing

    xticklab = {'0','30','60','90','120'};
    xtick = [0,30,60,90,120]; 
    edges = 15:7.5:110;
    figname = strcat(filename,'LOCSdiffALL','_thrDOWN_',num2str(thrDOWN),'_thrUP_',num2str(thrUP),...
    '_pixfilt_',num2str(pixfilt),'_minPROM_',num2str(minPROM),'_pix_',num2str(pix(si,1)),...
    'medianW_',num2str(medianW),'.fig');
    xlabs = 'Interspacing (nm)';
    ytick = [0,0.015,0.03];
    yticklab = {'0','0.015','0.03'};
    data = dataInterspace;

elseif sel == 2 % plot filament width
    xticklab = {'0','10','20','30','40','50','60','70'};
    xtick = [0,10,20,30,40,50,60,70]; 
    edges = 0:7.5:100;
    figname = strcat(filename,'WIDTHall','_thrDOWN_',num2str(thrDOWN),'_thrUP_',num2str(thrUP),...
    '_pixfilt_',num2str(pixfilt),'_minPROM_',num2str(minPROM),'_pix_',num2str(pix(si,1)),...
    'medianW_',num2str(medianW),'.fig');
    xlabs = 'Width (nm)';
    ytick = [0,0.03,0.06];
    yticklab = {'0','0.03','0.06'};
    data = dataWidth;
end
% figure properties
fontname='Helvetica'; % Fontsize name
tickdir = 'out';
ticksize= [0.02 0.035]; % Fontsize legend
alw = 1.5;    % AxesLineWidth
fsz = 10;      % Fontsize
lw = 1; %line width
fszl = 8;
f1 = figure;
h1 = histogram(data,edges,'Normalization','pdf'); % plot the histogram data
h1.FaceColor = violet;
h1.EdgeColor = 'None';
set(gca,'XTick',xtick) 
set(gca,'YTick',ytick)   
axis square
xl = xlabel(gca,xlabs, 'Interpreter', 'none');
set(xl,'Fontname',fontname, 'Fontsize', fsz)    
set(gca,'Fontname',fontname,'FontSize',fsz)    
set(gca,'box','off');   
yl = ylabel(gca, 'PDF', 'Interpreter', 'none');
set(yl,'Fontname',fontname, 'Fontsize', fsz)  
set(gca,'XTickLabel',xticklab)
set(gca,'YTickLabel',yticklab)
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
xlim(gca,[xtick(1),xtick(end)])
ylim(gca,[ytick(1),ytick(end)])  
 set(gca,'box','off');
 set(gca,'TickDir', tickdir);
set(gca,'TickLength', ticksize);
pos = get(f1, 'Position');
set(f1, 'Position', [pos(1)-100 pos(2)-100 width*80, height*80]); 
savefig(figname)
%saving the data
save(strcat(filename,'LOCSdiffALL','_thrDOWN_',num2str(thrDOWN),'_thrUP_',num2str(thrUP),...
    '_pixfilt_',num2str(pixfilt),'_minPROM_',num2str(minPROM),'_pix_',num2str(pix(si,1)),...
    'medianW_',num2str(medianW),'.mat'));