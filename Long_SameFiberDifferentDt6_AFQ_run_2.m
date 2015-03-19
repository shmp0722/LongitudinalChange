function afq = Long_SameFiberDifferentDt6_AFQ_run_2
%
% 
% 
% SO @ Vista Team 2015
%% Make directory structure for each subject
out_dir = '/sni-storage/wandell/biac2/wandell/data/Longitudinal_LHON/result';

homeDir1 = '/sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
homeDir3 = '/sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan3';
% subDir = dir(fullfile(homeDir,'LHON*')); 
subDir = {...
    'LHON6-SS-20121221-DWI'
    'LHON6-SS-20131206-DWI'
    'LHON7-TT-dMRI-Anatomy'
    'LHON7-TT-2nd-20150222'};

for ii = 1:2
    sub_dirs{ii} = fullfile(homeDir1, subDir{ii},'dwi_2nd');
end
for ii = 3:4
    sub_dirs{ii} = fullfile(homeDir3, subDir{ii},'dwi_2nd');
end

sub_group = [1 1 1 1];

% Now create and afq structure
afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group);

% set sae directory
afq = AFQ_set(afq, 'outdir',out_dir);
afq = AFQ_set(afq, 'outname','afq_PrePost.mat');
afq.params.showfigs = 0;
% 

%% Run AFQ on these subjects
afq = AFQ_run(sub_dirs, sub_group, afq);

%% Callosal segmentation

afq = AFQ_set(afq,'outname','afq_Whole_PrePost2.mat');

afq = AFQ_SegmentCallosum(afq);

%% add OR and OT
% change save name
afq = AFQ_set(afq,'outname','afq_Whole_PrePost2_OTOR.mat');
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

%%
  [norms, patient_data, control_data, afq] = AFQ_ComputeNorms(afq);