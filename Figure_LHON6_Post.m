function Figure_LHON6_Post
% Create figures illustrating the OR, optic tract, FA on the these tracts,
% and possibly the LGN position
%
% Repository dependencies
%    VISTASOFT
%    AFQ
%    LHON2
%
% SO Vista lab, 2014

%% Identify the directories and subject types in the study
% The full call can be
[homeDir,subDir] = Tama_subj;

%% load fiber groups (fg) and ROI files% select the subject{i}

% This selects a specific
whichSubject = 15; % Post = 27

% These directories are where we keep the data at Stanford.
% The pointers must be directed to any site.
SubDir=fullfile(homeDir,subDir{whichSubject});
ORfgDir = fullfile(SubDir,'/dwi_2nd/fibers');
% OCFfgDir= fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OCF_Top50K_fsV1V2_3mm');
dirOTfg= fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OT_5K');

% dirROI = fullfile(SubDir,'/dwi_2nd/ROIs');
dt6 =fullfile(homeDir,subDir{27},'/dwi_2nd/dt6.mat');

% Load fiber groups

% define fg names
Fg = {'LOTD3L2_1206.pdb','ROTD3L2_1206.pdb','LOR1206_D4L4.pdb','ROR1206_D4L4.pdb'};
% Optic radiation
fgrOR = fgRead(fullfile(SubDir,'dwi_2nd/fibers',Fg{4}));
fglOR = fgRead(fullfile(SubDir,'dwi_2nd/fibers',Fg{3}));

% Optic tract
fglOT = fgRead(fullfile(SubDir,'dwi_2nd/fibers',Fg{1}));
fgrOT = fgRead(fullfile(SubDir,'dwi_2nd/fibers',Fg{2}));

FG = {fgrOR , fglOR, fglOT, fgrOT};

% Load dt6
dt = dtiLoadDt6(dt6);
t1 = niftiRead(dt.files.t1);

% load ROIs for Figure 3, but not Figure 4
dirROI = fullfile(SubDir,'dwi_2nd','ROIs');
roiList = {'Optic-Chiasm.mat','Rt-LGN4.mat','Lt-LGN4.mat','lh_V1_smooth3mm_NOT.mat','rh_V1_smooth3mm_NOT.mat'};

%% draw visual pathway figure using AFQ_render
% Fig4 A

% ORs
mrvNewGraphWin;hold on;

AFQ_RenderFibers(fgrOR, 'newfig', [0],'numfibers', 1000 ,'color', [0.854,0.65,0.125],'radius',[0.5,2]); %fg() = fg
AFQ_RenderFibers(fglOR, 'newfig', [0],'numfibers', 1000 ,'color', [0.854,0.65,0.125],'radius',[0.5,2]); %fg() = fg

% Occipital callosal fibers
% AFQ_RenderFibers(fg3, 'newfig', [0],'numfibers', 100 ,'color', [0.4, 0.7, 0.7],'radius',[0.5,2]); %fg() = fg

%Optic Tract
AFQ_RenderFibers(fglOT, 'newfig', [0],'numfibers', 50 ,'color', [0.67,0.27,0.51],'radius',[0.5,2]); %fg() = fg
AFQ_RenderFibers(fgrOT, 'newfig', [0],'numfibers', 50 ,'color', [0.67,0.27,0.51],'radius',[0.5,2]); %fg() = fg

% % add ROIs if you have the LGN
% theseROIS = 1:5;
% for k = theseROIS
%     Roi = dtiReadRoi(fullfile(dirROI, roiList{k}));
%     AFQ_RenderRoi(Roi);
% end

% T1w
AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);

% adjust figure
view(0 ,89);
set(gcf,'Color',[1 1 1])
set(gca,'Color',[1 1 1])
axis image
axis off
camlight('headlight');
title('Optic tract and optic radiation')
hold off;

%% Fig4 B
% Overlay the FA for this subject on the OR and OT

% Set the value for overlay to 'fa'
if(~exist('valName','var') || isempty(valName))
    valName = 'fa'; % 'fa','md','ad', and 'rd' are available. Change value range
end

mrvNewGraphWin;hold on;
for kk = 1:length(FG)
    % Get the FA values from the fiber group
    vals = dtiGetValFromFibers(dt.dt6,FG{kk},inv(dt.xformToAcpc),valName);
    
    rgb = vals2colormap(vals);
    switch kk
        case {1,2}
            AFQ_RenderFibers(FG{kk},'color',rgb,'crange',[0.3 0.7],'newfig',0,'numfibers',1000);
        case {3,4}
            AFQ_RenderFibers(FG{kk},'color',rgb,'crange',[0.3 0.7],'newfig',0);
    end
end

% Put T1w
t1 = niftiRead(dt.files.t1);
AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);

axis image, axis off, view(0,89)
cb = colorbar('location','eastoutside');
caxis([0.3 0.7])
T = get(cb,'Title'); set(T,'string','FA','FontSize',14);


%% Fig4 C
% Fa values averaged along tracts

mrvNewGraphWin; hold on;

for kk = 1:length(FG)
    % TractProfile along current tract
    TractProfile = SO_FiberValsInTractProfiles(FG{kk},dt,'AP',100,1);
    
    % params
    radius = 3;
    subdivs = 20;
    crange = [0.3 0.7];
    cmap    = 'jet';
    newfig = 0;
    
    % render core fiber with averaged FA values 
    AFQ_RenderTractProfile(TractProfile.coords.acpc, radius, TractProfile.vals.fa, subdivs, cmap, crange, newfig)
end
% Put T1w
AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);

axis image, axis off, view(0,89)
camlight('headlight');
title('Core fiber with averaged FA value')
% colorbar('off')
colorbar('location','eastoutside');
caxis([0.3 0.7])

%% End

