function Longitudinal 


homeDir = '/sni-storage/wandell/biac2/wandell/data/LHON_LongitudinalChange';

% subDir = dir(fullfile(homeDir,'LHON*')); 
subDir = {...
    'LHON6-SS-20121221-DWI'
    'LHON6-SS-20131206-DWI'
    'LHON7-TT-dMRI-Anatomy'
    'LHON7-TT-2nd-20150222'};

Fg = {'LOTD4L4_1206.pdb','ROTD4L4_1206.pdb','LOR1206_D4L4.pdb','ROR1206_D4L4.pdb'};


%% Check if fg exist  

for ii =1 : length(subDir)
    fgDir = fullfile(homeDir,subDir{ii},'/dwi_2nd/fibers');
    for jj =1:4
       Existence(ii,jj) = exist(fullfile(fgDir,Fg{jj}));
    end
end
 
%% command run osmosis-dti-rrmse.py with wmMask
for i =1:length(subDir)
    cd(fullfile(homeDir, subDir{i},'raw'))
%     if ~exist('wmMask.nii.gz'),
        copyfile(fullfile(homeDir, subDir{i},'dwi_2nd/bin/wmMask.nii.gz'),fullfile(homeDir, subDir{i},'raw'));
%     end
    !osmosis-dti-rrmse.py dwi1st_aligned_trilin.nii.gz dwi1st_aligned_trilin.bvecs dwi1st_aligned_trilin.bvals dwi2nd_aligned_trilin.nii.gz dwi2nd_aligned_trilin.bvecs dwi2nd_aligned_trilin.bvals dti_rrmse_wmMask.nii.gz --mask_file wmMask.nii.gz

end
%% command run Osmosis-dti-rsquared SO
for i =1:length(subDir)
    cd(fullfile(homeDir, subDir{i},'raw'))
    !osmosis-dti-rsquared.py dwi2nd_aligned_trilin.nii.gz dwi2nd_aligned_trilin.bvecs dwi2nd_aligned_trilin.bvals dwi2nd_aligned_trilin.nii.gz dwi2nd_aligned_trilin.bvecs dwi2nd_aligned_trilin.bvals dti2nd_rsquared.nii.gz
end