function afq = Long_SameFiberDifferentDt6_AFQ_run
%
% 
% 
% SO @ Vista Team 2015
%% Make directory structure for each subject
homeDir = '/sni-storage/wandell/biac2/wandell/data/Longitudinal_LHON';

% subDir = dir(fullfile(homeDir,'LHON*')); 
subDir = {...
    'LHON6_pre'
    'LHON6_post'
    'LHON7_pre'
    'LHON7_post'};

for ii = 1:length(subDir)
    sub_dirs{ii} = fullfile(homeDir, subDir{ii},'dwi_2nd');
end

sub_group = [1 1 1 1];

% Now create and afq structure
afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group);

% set sae directory
afq = AFQ_set(afq, 'outdir',fullfile(homeDir,'/results_2'));
afq = AFQ_set(afq, 'outname','afq_PrePost.mat');
afq.params.showfigs = 0;
% 

%% Run AFQ on these subjects
afq = AFQ_run(sub_dirs, sub_group, afq);

%% Callosal segmentation

afq = AFQ_set(afq,'outname','afq_Whole_PrePost.mat');

afq = AFQ_SegmentCallosum(afq);

%% add OR and OT
% change save name
afq = AFQ_set(afq,'outname','afq_Whole_PrePost_sameOTOR.mat');
% 
afq.params.clip2rois = 0;
afq.params.cleanFibers = 0;
% afq.params.computenorms = 1;

% Fiber tracts to be added
Fg = {'LOTD4L4_1206.pdb','ROTD4L4_1206.pdb','LOR1206_D4L4.pdb','ROR1206_D4L4.pdb'};

% L-optic tract
fgName =  Fg{1};
roi1Name = '85_Optic-Chiasm.mat';
roi2Name = 'Lt-LGN4.mat';

afq = SO_AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1,0,[],0);

% R-optic tract
fgName =  Fg{2};
roi1Name = '85_Optic-Chiasm.mat';
roi2Name = 'Rt-LGN4.mat';

afq = SO_AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1,0,[],0);

% L-optic radiation
fgName =  Fg{3};
roi1Name = 'Lt-LGN4.mat';
roi2Name = 'lh_V1_smooth3mm_NOT.mat';

afq = SO_AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1,0,[],0);

% R-optic radiation
fgName =  Fg{4};
roi1Name = 'Rt-LGN4.mat';
roi2Name = 'rh_V1_smooth3mm_NOT.mat';

afq = SO_AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1,0,[],0);

