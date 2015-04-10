 %% Compute Tract Profiles
    
 homeDir = '/sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
 homeDir3 = '/sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
 sub_dirs = {'LHON6-SS-20121221-DWI','LHON6-SS-20131206-DWI'};
 sub_dirs3 = {'LHON7-TT-dMRI-Anatomy','LHON7-TT-2nd-20150222'};

 
 dtPre6 = dtiLoadDt6(fullfile(homeDir,sub_dirs{1}, 'dwi_2nd/dt6.mat')); 
 dtPost6 = dtiLoadDt6(fullfile(homeDir,sub_dirs{2}, 'dwi_2nd/dt6.mat')); 
 substruct = dtPost6.dt6- dtPre6.dt6;

%% TractProfile

% define fg names
Fg = {'LOTD4L4_1206.pdb','ROTD4L4_1206.pdb','LOR1206_D4L4.pdb','ROR1206_D4L4.pdb'};

% Calculate diffusivities along with fiber tractcdt
for jj = 1:4;
    Cur_fg = fgRead(fullfile(homeDir,sub_dirs{1},'dwi_2nd/fibers',Fg{jj}));
    
    TractProfile{1,jj} = SO_FiberValsInTractProfiles(Cur_fg,dtPre6,'AP',100,1);
    TractProfile{2,jj} = SO_FiberValsInTractProfiles(Cur_fg,dtPost6,'AP',100,1);
end
 
 
%% Load MoriGroup
MoriGroup = '/sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/LHON6-SS-20121221-DWI/dwi_2nd/fibers/MoriGroups.mat';



fg_classified =  dtiLoadFiberGroup(MoriGroup);
%% Define the name of the segmented fiber group

afq = AFQ_Create;

segName = AFQ_get(afq,'segfilename');
 
        fWeight = AFQ_get(afq,'fiber weighting');
        % By default Tract Profiles of diffusion properties will always be
        % calculated
        [fa, md, rd, ad, cl, vol, TractProfile] = AFQ_ComputeTractProperties(fg_classified, dtPre6 , afq.params.numberOfNodes, afq.params.clip2rois, fullfile(homeDir,sub_dirs{1}));
        
        % Parameterize the shape of each fiber group with calculations of
        % curvature and torsion at each point and add it to the tract
        % profile
        [curv, tors, TractProfile] = AFQ_ParamaterizeTractShape(fg_classified, TractProfile);
        
        % Calculate the volume of each Tract Profile
        TractProfile = AFQ_TractProfileVolume(TractProfile);
        
        % Add values to the afq structure
        afq = AFQ_set(afq,'vals','subnum',ii,'fa',fa,'md',md,'rd',rd,...
            'ad',ad,'cl',cl,'curvature',curv,'torsion',tors,'volume',vol);
        
        % Add Tract Profiles to the afq structure
        afq = AFQ_set(afq,'tract profile','subnum',ii,TractProfile);
        
        % If any other images were supplied calculate a Tract Profile for that
        % parameter
        numimages = AFQ_get(afq, 'numimages');
        if numimages > 0;
            for jj = 1:numimages
                % Read the image file
                image = readFileNifti(afq.files.images(jj).path{ii});
                % Resample image to match dwi resolution if desired
                if AFQ_get(afq,'imresample')
                    image = mrAnatResampleToNifti(image, fullfile(afq.sub_dirs{ii},'bin','b0.nii.gz'),[],[7 7 7 0 0 0]);
                end
                % Compute a Tract Profile for that image
                imagevals = AFQ_ComputeTractProperties(fg_classified, image, afq.params.numberOfNodes, afq.params.clip2rois, sub_dirs{ii}, fWeight, afq);
                % Add values to the afq structure
                afq = AFQ_set(afq,'vals','subnum',ii,afq.files.images(jj).name, imagevals);
                clear imagevals
            end
        end
    else
        fprintf('\nTract Profiles already computed for subject %s',sub_dirs{ii});
    end
    
    % Save each iteration of afq run if an output directory was defined
    if ~isempty(AFQ_get(afq,'outdir')) && exist(AFQ_get(afq,'outdir'),'dir')
        if ~isempty(AFQ_get(afq,'outname'))
            outname = fullfile(AFQ_get(afq,'outdir'),AFQ_get(afq,'outname'));
        else
            outname = fullfile(AFQ_get(afq,'outdir'),['afq_' date]);
        end
        save(outname,'afq');
    end
    
    % clear the files that were computed for this subject
    clear fg fg_classified TractProfile
end

%% Compute Control Group Norms

% Check if norms should be computed
if AFQ_get(afq,'computenorms')
    % If no control group was entered then norms will only contain nans.
    [norms, patient_data, control_data, afq] = AFQ_ComputeNorms(afq);
end

%% Identify Patients With Abnormal Diffusion Measurements

property = 'FA';
% Only run AFQ_ComparePatientsToNorms if norms were computed for the
% property of interest for each tract
if AFQ_get(afq,'computenorms') == 0 || sum(isnan(eval(['norms.mean' property '(1,:)']))) == 20
    fprintf('\nnorms are empty. skipping AFQ_ComparePatientsToNorms\n')
    % If there are no norms than we can not identify which subjects are
    % abnormal.  Hence these variables will be set to nan.
    abn       = nan(length(sub_dirs),1);
    abnTracts = nan(length(sub_dirs),20);
elseif AFQ_get(afq,'number of patients') >=1
    [abn, abnTracts] = AFQ_ComparePatientsToNorms(patient_data, norms, afq.params.cutoff, property);
else
    abn = nan;
    abnTracts = nan;
end
%% Plot Abnormal Patients Against Control Population

% Only plot if norms were computed for each tract
if AFQ_get(afq,'computenorms') == 0 || sum(isnan(eval(['norms.mean' property '(1,:)']))) == 20
    fprintf('\nnorms are empty. Skipping AFQ_plot\n')
elseif ~exist('abn','var') || sum(isnan(abn))==1
    fprintf('\nNo patients. Skipping AFQ_plot\n')
elseif AFQ_get(afq,'showfigs');
    % percentiles to define normal range
    ci = afq.params.cutoff;
    % loop over tracts and plot abnormal subjects
    for jj = 1:20
        % Find subjects that show an abnormality on tract jj
        sub_nums = find(abnTracts(:,jj));
        % Generate a structure for a legend
        L = {};
        for ii = 1:length(sub_nums)
            L{ii} = num2str(sub_nums(ii));
        end
        AFQ_plot(norms, patient_data,'individual','ci',ci,'subjects',sub_nums,'tracts',jj,'legend',L)
        % AFQ_PlotResults(patient_data, norms, abn, afq.params.cutoff,property, afq.params.numberOfNodes, afq.params.outdir, afq.params.savefigs);
    end
end