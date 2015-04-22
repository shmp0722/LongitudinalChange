function Longitudianl_plot_LHON7
% Plot figure 5 showing individual FA value along the core of OR and optic tract.
%
% Repository dependencies
%    VISTASOFT
%    AFQ
%    LHON2
%
% SO Vista lab, 2014
%
% Shumpei Ogawa 2014

%% Identify the directories and subject types in the study
% The full call can be
[~,subDir,~,CRD,LHON,Ctl,~] = Tama_subj2;

%% Load normal_TP data
% TPdata = fullfile('/Users/shumpei/Documents/MATLAB/git/LongitudinalChange/Tama2_TP_SD.mat');

TPdata = '/sni-storage/wandell/biac3/wandell7/shumpei/matlab/git/LongitudinalChange/Tama2_TP_SD.mat';
if ~exist(TPdata)
    TPdata = fullfile('/Users/shumpei/Documents/MATLAB/git/LongitudinalChange/Tama2_TP_SD.mat');
end

load(TPdata)
normal_TP =  TractProfile;
clear TPdata
%% Load patients' data

TPdata = '/sni-storage/wandell/biac3/wandell7/shumpei/matlab/git/LongitudinalChange/LHON7_TP.mat';

if ~exist(TPdata)
    TPdata = fullfile('/Users/shumpei/Documents/MATLAB/git/LongitudinalChange/LHON7_TP.mat');
end;
load(TPdata)

lhon_TP = TractProfile;
clear TractProfile;

%% R OT
% take values
sdID = 1;%:7
lhon_fib = [4,3,2,1];

for fibID = 1:4
    % make one sheet diffusivity
    % merge both hemisphere
    for subID = 1:length(normal_TP);
        if isempty(normal_TP{subID,fibID}{sdID}.nfibers);
            fa(subID,:) =nan(1,100);
        else
            fa(subID,:) =  normal_TP{subID,fibID}{sdID}.vals.fa;
        end;
        
        if isempty(normal_TP{subID,fibID}{sdID}.nfibers);
            md(subID,:) =nan(1,100);
        else
            md(subID,:) = normal_TP{subID,fibID}{sdID}.vals.md;
        end;
        
        if isempty(normal_TP{subID,fibID}{sdID}.nfibers);
            rd(subID,:) =nan(1,100);
        else
            rd(subID,:) = normal_TP{subID,fibID}{sdID}.vals.rd;
        end;
        
        if isempty(normal_TP{subID,fibID}{sdID}.nfibers);
            ad(subID,:) =nan(1,100);
        else
            ad(subID,:) = normal_TP{subID,fibID}{sdID}.vals.ad;
        end;
    end
    
    %% Render plots comparing this subject with normal distribution 
    Property = {'fa','md','ad','rd'};
    
    for kk = 1:length(Property)
        %% Optic Tract
        property = Property{kk};
        switch(property)
            case {'FA' 'fa' 'fractional anisotropy'}
                Nval = fa(Ctl,:);
                Ppre  = lhon_TP{1,lhon_fib(fibID)}.vals.fa;
                Ppost = lhon_TP{2,lhon_fib(fibID)}.vals.fa;
            case {'MD' 'md' 'mean diffusivity'}
                Nval = md(Ctl,:);
                Ppre = lhon_TP{1,lhon_fib(fibID)}.vals.md;
                Ppost = lhon_TP{2,lhon_fib(fibID)}.vals.md;
            case {'RD' 'rd' 'radial diffusivity'}
                Nval = rd(Ctl,:);
                Ppre = lhon_TP{1,lhon_fib(fibID)}.vals.rd;
                Ppost = lhon_TP{2,lhon_fib(fibID)}.vals.rd;
            case {'AD' 'ad' 'axial diffusivity'}
                Nval = ad(Ctl,:);
                Ppre = lhon_TP{1,lhon_fib(fibID)}.vals.ad;
                Ppost = lhon_TP{2,lhon_fib(fibID)}.vals.ad;
        end
        
        figure; hold on;
        X = 1:100;
        c = lines(100);
        
        % put bars based on ANOVA (p<0.01)
        % bar(1:100,Portion,1.0)
        
        % Control
        st = nanstd(Nval,1);
        m   = nanmean(Nval);
        
        % render control subjects range
        A3 = area(m+2*st);
        A1 = area(m+st);
        A2 = area(m-st);
        A4 = area(m-2*st);
        
        % set color and style
        set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
        set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
        set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
        set(A4,'FaceColor',[1 1 1],'linestyle','none')
        
        plot(m,'color',[0 0 0], 'linewidth',3 )
        
        % add LHON6's FA
        plot(X,Ppre,'--','Color',c(3,:),...
            'linewidth',2);
        
        plot(X,Ppost,'Color',c(3,:),...
            'linewidth',2);
        
        % add label
        xlabel('Location','fontName','Times','fontSize',14);
        ylabel(upper(property),'fontName','Times','fontSize',14);
        title(sprintf('%s',normal_TP{subID,fibID}{1}.name(1:3)),'fontName','Times','fontSize',14)
%         axis([10, 90 ,0.0, 0.8])
        Yticks =  get(gca,'ytick');
        Ylim =  get(gca,'ylim');
        set(gca,'ytick', Ylim)
        set(gca,'xtick',[10,90],'xticklabel',{'OT','LGN'});%,'ytick',[0,0.8]);
        % legend('2012','2013')
        
        % save the figure
       [p,f]= fileparts(TPdata);
        SaveName = ...
            fullfile(p,sprintf('%s_%s_%s.eps',f,normal_TP{subID,fibID}{1}.name(1:3),property));
        saveas(gcf,SaveName,'psc2')
        
    end
end
%% OR
fibID = 1;
for subID = 1:length(subDir);
    if isempty(normal_TP{subID,fibID}{sdID}.nfibers);
        fa(subID,:) =nan(1,100);
    else
        fa(subID,:) =  mean([normal_TP{subID,fibID}{sdID}.vals.fa;...
            normal_TP{subID,fibID+1}{sdID}.vals.fa]);
    end;
    
    if isempty(normal_TP{subID,fibID}{sdID}.nfibers);
        md(subID,:) =nan(1,100);
    else
        md(subID,:) = mean([ normal_TP{subID,fibID}{sdID}.vals.md;...
            normal_TP{subID,fibID+1}{sdID}.vals.md]);
    end;
    
    if isempty(normal_TP{subID,fibID}{sdID}.nfibers);
        rd(subID,:) =nan(1,100);
    else
        rd(subID,:) = mean([ normal_TP{subID,fibID}{sdID}.vals.rd;...
            normal_TP{subID,fibID+1}{sdID}.vals.rd]);
    end;
    
    if isempty(normal_TP{subID,fibID}{sdID}.nfibers);
        ad(subID,:) =nan(1,100);
    else
        ad(subID,:) = mean([ normal_TP{subID,fibID}{sdID}.vals.ad;...
            normal_TP{subID,fibID+1}{sdID}.vals.ad]);
    end;
end

%% ANOVA
Ctl_Val =  fa(Ctl,:);
LHON_Val =  fa(LHON,:);
CRD_Val =  fa(CRD,:);

for jj= 1: 100
    pac = nan(14,3);
    pac(:,1)= Ctl_Val(:,jj);
    pac(1:6,2)= LHON_Val(:,jj);
    pac(1:5,3)= CRD_Val(:,jj);
    [p(jj),~,stats(jj)] = anova1(pac,[],'off');
    co = multcompare(stats(jj),'display','off');
    C{jj}=co;
end

Portion =  p<0.01;
%% OR
figure; hold on;

% put bars based on ANOVA (p<0.01)
bar(1:100,Portion,1.0)

% Control subjects data
st = nanstd(fa(Ctl,:),1);
m   = nanmean(fa(Ctl,:));

% render control subjects range
A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

% set color and style
set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')

% plot mean value
plot(m,'color',[0 0 0], 'linewidth',3)

% individual FA
for k = CRD %1:length(subDir)
    plot(X,fa(k,:),'Color',c(3,:),...
        'linewidth',1);
end
m   = nanmean(fa(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',2)


% add individual plot
for k = LHON %1:length(subDir)
    plot(X,fa(k,:),'Color',c(4,:),'linewidth',1);
end
% plot mean value
m   = nanmean(fa(LHON,:));
plot(X,m,'Color',c(4,:) ,'linewidth',2)

% add labels
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Fractional anisotropy','fontName','Times','fontSize',14);
axis([10, 90 ,0.2, 0.750001])
title('Optic radiation','fontName','Times','fontSize',14)


