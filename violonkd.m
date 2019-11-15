function [f1,ha1,l,xl,yl,hv,pl,med,avg] = violonkd(datviolin,bw,normfac,grpos,facecol,edgecol,mav,mmed,alp,...
    width,height,alw,fsz,lw,fszl,fontname,xlab,ylab,xtixklab)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% if nargin == 20
%     pl = 1;
% elseif nargin == 21
%     pl = varargin{1};
% end
legtag = 0;
if isempty(width)
    width = 3;     % Width in inches
end
if isempty(height)
    height = 3;    % Height in inches
end
if isempty(alw)
    alw = 1;    % AxesLineWidth
end
if isempty(fsz)
    fsz = 10;      % Fontsize
end
if isempty(lw)
    lw = 1.5;      % LineWidth
end

if isempty(fszl)
    fszl = 8; % Fontsize legend
end
if isempty(fontname)
    fontname = 'Helvetica';
end
if nargin == 22
    plotflag = varargin{1};
    f1 = varargin{2};
    ha1 = varargin{3};
elseif nargin == 19
 plotflag = 1;
% else
%     error('wrong number of input argument')
end
if plotflag
f1 = figure;
ha1 = axes('Parent', f1);

end
set(ha1,'NextPlot','add');
ng = numel(datviolin);
if numel(bw) == 1
    bw = repmat(bw,[1 ng]);
end

if size(facecol,1) == 1
    facecol = repmat(facecol,[ng 1]);
end

if size(edgecol,1) == 1
    edgecol = repmat(edgecol,[ng 1]);
end

if isempty(grpos)
    grpos = 1:ng;
end
med = zeros(ng,1);
avg = zeros(ng,1);

for kk=1:ng

    if ~isempty(bw)
        [kdest(:,kk), xest(:,kk)]=ksdensity(datviolin{kk},'bandwidth',bw(kk),'Parent',ha1);
    else
        [kdest(:,kk), xest(:,kk)]=ksdensity(datviolin{kk},'Parent',ha1);
    end
    if isempty(normfac)
        normfac = sum(isfinite(datviolin{kk}));
    end
%     kdest(:,kk) = kdest(:,kk)/sum(kdest(:,kk))/normfac;
       kdest(:,kk) = kdest(:,kk)/max(kdest(:,kk)).*normfac;
%     kdest=kdest/max(kdest)*0.3; %normalize

    med(kk,1)=nanmedian(datviolin{kk});
    avg(kk,1)=nanmean(datviolin{kk});
    if plotflag
     hv(kk)=fill([kdest(:,kk)+grpos(kk);flipud(grpos(kk)-kdest(:,kk))],...
         [xest(:,kk);flipud(xest(:,kk))],facecol(kk,:),...
         'FaceAlpha',alp,'EdgeColor',edgecol(kk,:));
    else
        hv = 0;
    end

    pl(1)=plot(mean([interp1(xest(:,kk),kdest(:,kk)+grpos(kk),avg(kk,1)), ...
        interp1(flipud(xest(:,kk)),flipud(grpos(kk)-kdest(:,kk)),avg(kk,1))]),...
        med(kk,1),'.','Color',mav,'MarkerSize',15,'Parent',ha1);

    pl(2)=plot([interp1(xest(:,kk),kdest(:,kk)+grpos(kk),avg(kk,1)), ...
        interp1(flipud(xest(:,kk)),flipud(grpos(kk)-kdest(:,kk)),avg(kk,1))],...
        [avg(kk,1) avg(kk,1)],':','Color',mmed,'LineWidth',3,'Parent',ha1);
    
   
end
% if legtag
 l = legend([pl(1) pl(2)],'Median','Mean');
 set(l,'Fontname',fontname, 'Fontsize', fszl)  
% end

if ~isempty(xlab)
    xl = xlabel(ha1, xlab);
    set(xl,'Fontname',fontname, 'Fontsize', fsz)   
else
    xl = [];
end
 
set(ha1,'Fontname',fontname,'FontSize',fsz)    
set(ha1,'box','off');   
if ~isempty(ylab)
yl = ylabel(ha1, ylab);
set(yl,'Fontname',fontname, 'Fontsize', fsz)  
else
    yl = [];
end

if ~isempty(xtixklab)
%     xtl = xticklabels(xtixklab);
%     set(xtl,'Fontname',fontname, 'Fontsize', fsz)
     set(ha1,'XTickLabel',xtixklab)
end
 set(ha1,'XTick',grpos) 

set(ha1, 'FontSize', fsz, 'LineWidth', alw); 
set(ha1,'box','off');
pos = get(f1, 'Position');
set(f1, 'Position', [pos(1)-100 pos(2)-100 width*80, height*80]); %<- Set size
set(f1,'color','w')
set(f1,'InvertHardcopy','on');
set(f1,'PaperUnits', 'inches');

end

