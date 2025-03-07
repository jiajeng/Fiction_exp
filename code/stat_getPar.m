function stat_getPar(filepath,evntfile,subpath,varargin)
    % get X and Y value
    % X --> frequency band
    % Y --> subject thinks this story is positive or negative * arousal
    % beh --> beh data
    % optional input:
    % freq_Unit --> 'string', frequency band feature unit,
    %                         'rel', relative power,
    %                         'abs', absolute power.
    % model --> 'string', model type,
    %                     'Arousal_pn', Y : arousal*think_positive_or_negative(1 or -1)
    %                                   X : frequency band
    %                     'Arousal', Y : arousal
    %                                X : frequency band, think_positive_or_negative(1 or -1)

    varname = varargin(1:2:end);
    varvar = varargin(2:2:end);
    for i = 1:length(varname)
        v = varname{i};
        switch v
            case 'freq_Unit'
                freq_Unit = varvar{i};
                if class(freq_Unit)~="char" && class(freq_Unit)~="string"
                    error("freq_Unit data type is char or string, detect input is %s",class(freq_Unit));
                end
            case 'model'
                modl = varvar{i};
                if class(modl)~="char" && class(modl)~="string"
                    error("modl data type is char or string, detect input is %s",class(modl));
                end
        end
    end
    if ~exist("freq_Unit",'var')
        freq_Unit = 'abs';
    end
    if ~exist("modl",'var')
        modl = 'Arousal_pn';
    end


    if any(contains(filepath,'*'))
        Trialfile = dir(filepath);
        filepath = fullfile(Trialfile.folder,Trialfile.name);
    end
    Trialfile = {dir(fullfile(filepath,'*.mat')).name};
    TrialID = squeeze(split(Trialfile,'_'));
    TrialID = squeeze(split(TrialID(:,1),'t'));
    TrialID = cellfun(@str2double,TrialID(:,2));

    evtTab = readtable(evntfile);
    evtID = table2array(evtTab(:,1));
    evtTab = evtTab(arrayfun(@(x) find(evtID == x),TrialID),:);
    
    % condition is binominal 0 or 1 | neg. or pos.
    thikpn = num2str(evtTab.Condition3); % bit1 : 3 = neg. 4 = pos.
    thikpn = cellfun(@(x) x(~(x==' ')), mat2cell(thikpn, ones(1,size(thikpn,1)),size(thikpn,2)), 'UniformOutput', false);
    thikpn = cellfun(@(x) x(1),thikpn);
    thikpn = double(thikpn=='3');
    
    % Y is arousal
    switch modl
        case "Arousal_pn"
            thikpn(thikpn==0) = -1;
            Y = evtTab.Arousal.*thikpn;
            Y_name = {'RespondeEmotion*arousal'};
        case "Arousal"
            Y = evtTab.Arousal;
            Y_name = {'arousal'};
        case "Arousal_p"
            Y = evtTab.Arousal;
            Y_name = {'arousal'};
            Y = Y(thikpn==1,:);
        case "Arousal_n"
            Y = evtTab.Arousal;
            Y_name = {'arousal'};
            Y = Y(thikpn==0,:);
    end
   
    % X freqBand (trial x nfreqBand)
    load(fullfile(filepath,Trialfile{1})); % res
    CHANNELNAME = fieldnames(res);
    FB_name = fieldnames(res.(CHANNELNAME{1}).par_1.([freq_Unit,'Band']));
    X = struct();
    x = nan(length(TrialID),length(FB_name));
    for chi = 1:length(CHANNELNAME)
        for ti = 1:length(TrialID)
            load(fullfile(filepath,Trialfile{ti}));
            for fbi = 1:length(FB_name)
                x(ti,fbi) = res.(CHANNELNAME{chi}).par_1.([freq_Unit,'Band']).(FB_name{fbi});
            end
        end
        switch modl
            case "Arousal_pn"
                X.(CHANNELNAME{chi}) = x;
                X_name = FB_name;
            case "Arousal"
                X.(CHANNELNAME{chi}) = [x,thikpn];
                X_name = [FB_name',{'contrast'}];
            case "Arousal_p"
                X.(CHANNELNAME{chi}) = x(thikpn==1,:);
                X_name = FB_name;
            case "Arousal_n"
                X.(CHANNELNAME{chi}) = x(thikpn==0,:);
                X_name = FB_name;
        end
    end
    
    % effect [subject, IRI 4 feature, Sex, Age]
    info = readcell(fullfile(subpath,'info.txt'));
    info(:,2) = [];
    info = reshape(info',[],1);
    info = dictionary(info{:});
    effect = [info("Age_"), ... % Age
              info("gender_"), ... % Sex
              info("Fantasy_IRI(戴氏情感活動指標)-1"), ... % IRI fantasy
              info("Perspective_IRI-2"), ... % IRI perspetive
              info("Empathic_IRI-3"), ... % IRI Empathic
              info("Distress_IRI-4") % IRI Distress
              ];
    effect = str2double(effect);

    effect_name = {'Age','Sex','IRI_Fantasy','IRI_Perspective','IRI_Empathic','IRI_Distress'};
  
    outputpath = fullfile(filepath,'..','GLM',modl);
    if ~exist(outputpath,'dir'), mkdir(outputpath); end
    save(fullfile(outputpath,'Par.mat'),"X","Y","effect","X_name","Y_name","effect_name");
    
end