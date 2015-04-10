function Longitudianl_plot
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
TPdata = fullfile('/Users/shumpei/Documents/MATLAB/git/LongitudinalChange/Tama2_TP_SD.mat');
load(TPdata)

normal_TP =  TractProfile;

%% Load patients' data

TPdata = fullfile('/Users/shumpei/Documents/MATLAB/git/LongitudinalChange/LHON6_TP.mat');

lhon_TP = TractProfile;
clear TractProfile;

%% Figure 5A
% indivisual FA value along optic tract

% take values
fibID =3; %
sdID = 1;%:7
% make one sheet diffusivity
% merge both hemisphere
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
Ctl_fa =  fa(Ctl,:);
LHON_fa =  fa(LHON,:);
CRD_fa =  fa(CRD,:);

for jj= 1: 100
    pac = nan(14,3);
    pac(:,1)= Ctl_fa(:,jj);
    pac(1:6,2)= LHON_fa(:,jj);
    pac(1:5,3)= CRD_fa(:,jj);
    [p(jj),~,stats(jj)] = anova1(pac,[],'off');
    co = multcompare(stats(jj),'display','off');
    C{jj}=co;
end
Portion =  p<0.01; % where is most effected

%% Optic Tract
figure; hold on;
X = 1:100;
c = lines(100);

% put bars based on ANOVA (p<0.01)
% bar(1:100,Portion,1.0)

% Control
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

plot(m,'color',[0 0 0], 'linewidth',3 )

% add LHON6's FA

plot(lhon_TP{1,1}

% % add individual FA plot
% for k = CRD %1:length(subDir)
%     plot(X,fa(k,:),'Color',c(3,:),...
%         'linewidth',1);
% end
% m   = nanmean(fa(CRD,:));
% plot(X,m,'Color',c(3,:) ,'linewidth',3)
% 
% 
% % add individual
% for k = LHON %1:length(subDir)
%     plot(X,fa(k,:),'Color',c(4,:),'linewidth',1);
% end
% % plot mean value
% m   = nanmean(fa(LHON,:));
% plot(X,m,'Color',c(4,:) ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Fractional anisotropy','fontName','Times','fontSize',14);
title('Optic tract','fontName','Times','fontSize',14)
axis([10, 90 ,0.0, 0.600001])

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
Ctl_fa =  fa(Ctl,:);
LHON_fa =  fa(LHON,:);
CRD_fa =  fa(CRD,:);

for jj= 1: 100
    pac = nan(14,3);
    pac(:,1)= Ctl_fa(:,jj);
    pac(1:6,2)= LHON_fa(:,jj);
    pac(1:5,3)= CRD_fa(:,jj);
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


