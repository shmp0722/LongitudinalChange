 %% Compute Tract Profiles
    
 homeDir = '/sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
 homeDir3 = '/sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan3';
 sub_dirs = {'LHON6-SS-20121221-DWI','LHON6-SS-20131206-DWI'};
 sub_dirs3 = {'LHON7-TT-dMRI-Anatomy','LHON7-TT-2nd-20150222'};

 
 dtPre6 = dtiLoadDt6(fullfile(homeDir,sub_dirs{1}, 'dwi_2nd/dt6.mat')); 
 dtPost6 = dtiLoadDt6(fullfile(homeDir,sub_dirs{2}, 'dwi_2nd/dt6.mat')); 
 substruct = dtPost6.dt6- dtPre6.dt6;

% define fg names
Fg = {'LOTD4L4_1206.pdb','ROTD4L4_1206.pdb','LOR1206_D4L4.pdb','ROR1206_D4L4.pdb'};

%% TractProfile
% Calculate diffusivities along with fiber tractcdt
for jj = 1:4;
    Cur_fg = fgRead(fullfile(homeDir,sub_dirs{1},'dwi_2nd/fibers',Fg{jj}));
    TractProfile{1,jj} = SO_FiberValsInTractProfiles(Cur_fg,dtPre6,'AP',100,1);
    TractProfile{2,jj} = SO_FiberValsInTractProfiles(Cur_fg,dtPost6,'AP',100,1);
end

%% LHON7
dtPre6 = dtiLoadDt6(fullfile(homeDir3,sub_dirs3{1}, 'dwi_2nd/dt6.mat')); 
dtPost6 = dtiLoadDt6(fullfile(homeDir3,sub_dirs3{2}, 'dwi_2nd/dt6.mat')); 
% substruct = dtPost6.dt6- dtPre6.dt6;

%% TractProfile
% Calculate diffusivities along with fiber tractcdt
for jj = 1:4;
    Cur_fg = fgRead(fullfile(homeDir3,sub_dirs3{1},'dwi_2nd/fibers',Fg{jj}));
    TractProfile{1,jj} = SO_FiberValsInTractProfiles(Cur_fg,dtPre6,'AP',100,1);
    TractProfile{2,jj} = SO_FiberValsInTractProfiles(Cur_fg,dtPost6,'AP',100,1);
end

%% JMD3-AK
dtPre6 = dtiLoadDt6(fullfile(homeDir,'JMD3-AK-20121026-DWI/dwi_2nd/dt6.mat')); 
dtPost6 = dtiLoadDt6(fullfile(homeDir,'JMD3-AK-20140228-dMRI/dwi_2nd/dt6.mat')); 

%% TractProfile
% Calculate diffusivities along with fiber tractcdt
for jj = 1:4;
    Cur_fg = fgRead(fullfile(homeDir,'JMD3-AK-20121026-DWI/dwi_2nd/fibers',Fg{jj}));
    TractProfile{1,jj} = SO_FiberValsInTractProfiles(Cur_fg,dtPre6,'AP',100,1);
    TractProfile{2,jj} = SO_FiberValsInTractProfiles(Cur_fg,dtPost6,'AP',100,1);
end
save JMD3AK_TP TractProfile