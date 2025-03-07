%%  s32(39) 好像是eeg event有問題 
close all;clear;
rawPath = 'E:\Fiction_experiment\Data';
evtPath = 'E:\Fiction_experiment\Data\behave\evtList';
nevtPath = 'E:\Fiction_experiment\Data\behave\newTriallist';
eDatPath = 'E:\Fiction_experiment\Data\behave\eDat';
sub = {dir(rawPath).name};
sub = sub(~contains(sub,'.') & ~contains(sub,'behave') & ~contains(sub,'Result'));

% resort trial define
% CHARA = {'克郎','小王子','小王子的朋友','晴美','浩介','漢斯','牧羊少年','瑪格麗特','簡愛','約瑟夫','艾迪','莉賽爾','少女莉賽爾','雄治','靜子','魯迪','麥克斯','水晶店老闆'};
% CONDI = {'31', '33', '41', '44'};

% flags
prep.evt = false;
prep.conv = false;
prep.megf = false;
prep.filt = false;
prep.asr = false;
prep.ICA = false;   
proc.epoch = false;
proc.rmoutlier = false;
proc.FT = false;
proc.stat = true;
proc.gstat = false;
proc.statplot = false;
modl = 'Arousal_p';

for nsub = 1:length(sub)
    if nsub==39,continue;end
    %% orgnize event file 
    if prep.evt
        % eDat file 2 event file 
        eDatfile = {dir(eDatPath).name};
        idx = contains(eDatfile,sub{nsub});
        if any(idx)
            eDatfile = eDatfile{idx};
            eDat2evt(sub{nsub},fullfile(eDatPath,eDatfile),evtPath);
        end
        
        % resort event file 
        eventfile = {dir(evtPath).name};
        if any(contains(eventfile,sub{nsub}))
            eventfile = eventfile{contains(eventfile,sub{nsub})};
            resort_event(evtPath,eventfile,nevtPath)
        end
    end

    if prep.conv
        % convert file --> .vhdr to .set
        % ---------------convert file to .set file ------------------
        setfile = dir(fullfile(rawPath,sub{nsub},'**','eegSet'));
        if isempty(setfile)
            [errorfile,errorTab,outTab] = vhdr2set('vhdrpath',fullfile(rawPath,sub{nsub}));
            while ~isempty(errorfile)
                errorTab
                disp('check error file and fix it then continue to run');
                pause;
                [errorfile,errorTab,outTab] = vhdr2set('vhdrfile',errorfile);
            end
        end
        % output to vdhrfilepath/../eegSet/Raw
        %------------------------------------------------------------
    end

    % define event file
    eventfile = {dir(nevtPath).name};
    eventfile = eventfile{contains(eventfile,sub{nsub})};

    if prep.megf
        % merge all eeg file 
        prep_mergeFile(fullfile(nevtPath,eventfile),'filepath',fullfile(rawPath,sub{nsub},'**','eegSet','Raw'))
    end

    % --------------- filter --------------------------
    if prep.filt
        % filter 1-30 Hz
        prep_filt([1,30],'filepath',fullfile(rawPath,sub{nsub},'**','eegSet','RawMerg'));
    end
    % output to ./eegSet/filt
    % -------------------------------------------------

    % ---------------- ASR -----------------------------
    if prep.asr
        % asr threshold 20 std
        prep_asr('filepath',fullfile(rawPath,sub{nsub},'**','prep','f*.set'));
    end
    % --------------------------------------------------

    % --------------- ICA ----------------------
    if prep.ICA
        % retain brain and other 
        prep_ICA('filepath',fullfile(rawPath,sub{nsub},'**','prep','af*.set'))
    end
    % --------------------------------------------------

    % --------------- epoch data -----------------------
    if proc.epoch
        % epoch event 21 to 22(reading story)
        epoch_Data('21','22',fullfile(nevtPath,eventfile),'filepath',fullfile(rawPath,sub{nsub},'**','riaf*.set'),'get_dur_time',true)
        % every trial save a .set file
        % save trial duration in individual event file(add table.dur)

        % get all subject duration column save to a Readtime.xlsx file
        % Readtime(rawPath,nevtPath,CHARA,CONDI)
    end
    % --------------------------------------------------

    % -------------- remove outlier --------------------
    if proc.rmoutlier
        RmOutlier(fullfile(nevtPath,eventfile),fullfile(rawPath,sub{nsub},'**','process','trial*'),fullfile(rawPath,sub{nsub}));
    end
    % --------------------------------------------------

    % ------------ frequency translate -----------------
    if proc.FT
        FreqB('filepath',fullfile(rawPath,sub{nsub},'**','process','rm*'),'plot',1,'process',1)
    end
    % --------------------------------------------------

    % ---------------- statistical ---------------------
    if proc.stat
        stat_getPar(fullfile(rawPath,sub{nsub},'**','process','Freq_rmO*'),fullfile(nevtPath,eventfile),fullfile(rawPath,sub{nsub}), ...
            'model',modl);
        stat_1stlevel(fullfile(rawPath,sub{nsub},'**','process','GLM',modl))
    end
    % --------------------------------------------------
    
end


% LeffectN = {{'Age','Sex'},{'Age','Sex','IRI_Fantasy'},{'Age','Sex','IRI_Perspective'},{'Age','Sex','IRI_Empathic'},{'Age','Sex','IRI_Distress'},{'Age','Sex','IRI_Fantasy','IRI_Perspective','IRI_Empathic','IRI_Distress'}};
% effectN = {'Age','Sex','IRI_Fantasy'};
LeffectN = {{'Age','Sex','IRI_Fantasy','IRI_Perspective','IRI_Empathic','IRI_Distress'}};

for i = 1:length(LeffectN)
    % --------------- group level statistical --------------
    effectN = LeffectN{i};
    % effectN = {'Age','Sex'};
    folder = strjoin(effectN,'_');
    if proc.gstat
        if length(effectN) > 4
            stat_2ndlevel(fullfile(rawPath,'**','process','GLM',modl),modl, ...
                'effectN',effectN, ...
                'modlsep','Sex + Age*(IRI_Fantasy+IRI_Perspective+IRI_Empathic+IRI_Distress) + IRI_Perspective:IRI_Empathic + IRI_Empathic:IRI_Distress')
        else
            stat_2ndlevel(fullfile(rawPath,'**','process','GLM',modl),modl, ...
            'effectN',effectN)
        end
        stat_plotresult(fullfile(rawPath,'Result/2ndLevel',modl,folder,'/GLM.mat'));
    end
    % ------------------------------------------------------
    
    
    % --------------------- plot result --------------------
    if proc.statplot 
        % stat_CMP(fullfile(rawPath,'Result/2ndLevel',[modl,'_p'],folder), ...
        %          fullfile(rawPath,'Result/2ndLevel',[modl,'_n'],folder),...
        %          fullfile(rawPath,'Result/2ndLevel',[modl,'_p_n_cmp'],folder) ...
        %          );
        if length(effectN)>5
            % permutation
            % stat_plotPNresult_channel({fullfile(rawPath,'Result/2ndLevel/Arousal_p/',folder,'/GLM.mat'), ...
            %     fullfile(rawPath,'Result/2ndLevel/Arousal_n/',folder,'/GLM.mat')}, ...
            %     fullfile(rawPath,'Result/2ndLevel',[modl,'_p_n_cmp'],folder), ...
            %     fullfile(rawPath,'\Result\2ndLevel\Arousal_p_n_cmp_figure_perm',folder))
            % contrast
            stat_plotPNresult_channel({fullfile(rawPath,'Result/2ndLevel/Arousal_p/',folder,'/GLM.mat'), ...
                fullfile(rawPath,'Result/2ndLevel/Arousal_n/',folder,'/GLM.mat')}, ...
                fullfile(rawPath,'Result/2ndLevel',modl,folder), ...
                fullfile(rawPath,'\Result\2ndLevel\Arousal_p_n_figure',folder))
        else
            % permtataion
            stat_plotPNresult({fullfile(rawPath,'Result/2ndLevel/Arousal_p/',folder,'/GLM.mat'), ...
                fullfile(rawPath,'Result/2ndLevel/Arousal_n/',folder,'/GLM.mat')}, ...
                fullfile(rawPath,'Result/2ndLevel',[modl,'_p_n_cmp'],folder), ...
                fullfile(rawPath,'\Result\2ndLevel\Arousal_p_n_cmp_figure_perm',folder))
            % contrast
            stat_plotPNresult({fullfile(rawPath,'Result/2ndLevel/Arousal_p/',folder,'/GLM.mat'), ...
                fullfile(rawPath,'Result/2ndLevel/Arousal_n/',folder,'/GLM.mat')}, ...
                fullfile(rawPath,'Result/2ndLevel',modl,folder), ...
                fullfile(rawPath,'\Result\2ndLevel\Arousal_p_n_figure',folder))
        end
    end
end
% ------------------------------------------------------




