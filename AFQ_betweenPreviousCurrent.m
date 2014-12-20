function [Diff] = AFQ_betweenPreviousCurrent
%
% To compare the diffusivities between 2 measurement in different
%
%  Example:
%
%   AFQdata = '/home/jyeatman/matlab/svn/vistadata/AFQ'
%   dt = dtiLoadDt6(fullfile(AFQdata,'subj2','dt6.mat'))
%   fg_classified = AFQ_SegmentFiberGroups(dt)
%   numberOfNodes = 30; clip2rois = 1; subDir = fullfile(AFQdata,'subj2');
%   [fa md rd ad cl SuperFibersGroup] =
%   AFQ_ComputeTractProperties(fg_classified,dt,numberOfNodes,clip2rois,subDir)


%%
[homeDir, subDir] = Tama_subj;
[homeDir2, subDir2] = Tama_subj2;
[homeDir3, subDir3] = Tama_subj3;

%%
id2 = [16,17,18,13];
id3 = [11,13,12,17];

% boxes to contain values
Diff = struct;

for ii = 1:3 ;
    % take fg_classified from previous measurment
    if ii<4,
    sub_dir = fullfile(homeDir2,subDir2{id2(ii)},'dwi_2nd');
    else
        sub_dir = fullfile(homeDir,subDir{id2(ii)},'dwi_2nd');
    end
    fgDir =  fullfile(sub_dir,'fibers');    
    fg_classified = fgRead(fullfile(fgDir,'MoriGroups_Cortex_clean_D5_L4.mat'));
    
    dt = fullfile(sub_dir,'/dt6.mat');
    dt6_2 = dtiLoadDt6(dt);
    % t1 = niftiRead(dt.files.t1);
    dt6_3 = dtiLoadDt6(fullfile(homeDir3,subDir3{id3(ii)},'/dwi_2nd/dt6.mat'));
    
    %%
    numberOfNodes = 100;
    clip2rois     = 1;
    
    %% Compute TractProfile    
    
    [fa, md, rd, ad, cl, vol, TractProfile] = AFQ_ComputeTractProperties(fg_classified, dt6_2, numberOfNodes, clip2rois, sub_dir);
    
%     [fa(ii,1), md(ii,1), rd(ii,1), ad(ii,1), cl(ii,1), vol(ii,1), TractProfile{ii,1}] = AFQ_ComputeTractProperties(fg_classified, dt6_2, numberOfNodes, clip2rois, sub_dir);
    [fa2, md2, rd2, ad2, cl2, vol2, TractProfile2] = AFQ_ComputeTractProperties(fg_classified, dt6_3, numberOfNodes, clip2rois, sub_dir);
    
    %
    Diff.fa{ii}  = fa;
    Diff.md{ii}  = md;
    Diff.ad{ii}  = ad;
    Diff.rd{ii}  = rd;
    Diff.cl{ii}  = cl;
    Diff.cl{ii}  = vol;
    Diff.TP{ii}  = TractProfile;

    Diff.fa2{ii}  = fa2;
    Diff.md2{ii}  = md2;
    Diff.ad2{ii}  = ad2;
    Diff.rd2{ii}  = rd2;
    Diff.cl2{ii}  = cl2;
    Diff.cl2{ii}  = vol2;
    Diff.TP{ii}  = TractProfile2;
    
    clear fa md ad rd fa2 md2 ad2 rd2 TractProfile TractProfile2 
end

%%
save Diff Diff

 