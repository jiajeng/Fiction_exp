function insert_event(eventfile,varargin)
    % require input : 
    %         'eventfile', "string", eventfile path and filename 
    % optional input data(choose one) : 
    %         'filepath', "string", Get all .set file in this path
    %         'file', "struct", fields contains folder and name, dir func output
    %         'EEG', "struct", eeglab pattern
    %       !! input data priority, EEG > file > filepath
    %         
    % optional input : 
    %         'outpath', "string", store .set file in this path, if not
    %                              enter, default is in
    %                              /./process/trial_21to22_TF(according to data path--> last folder in data path)
    %        

    opathf = false;
    dataf = false;
    fbf = false;
    plotf = true;
    procf = true;

    % initial variable
    thres = 0.05;

    % set varin
    varname = varargin(1:2:end);
    varvar = varargin(2:2:end);
    for i = 1:length(varname)
        v = varname{i};
        switch v
            case 'filepath'
                filepath = varvar{i};
                if class(filepath) ~= "string" && class(filepath) ~= "char"
                    error(['filepath data type is "string" or "char", input is ',class(filepath)]); 
                end
                Df = false;
            case 'outpath'
                outpath = varvar{i};
                if class(outpath) ~= "string" && class(outpath) ~= "char"
                    error(['outpath data type is "string" or "char", input is ',class(outpath)]); 
                end
                opathf = true;
            case 'file'
                D = varvar{i};
                if class(D) ~= "struct"
                    error(['file data type is "struct", input is ',class(D)]); 
                end
                Df = true;
            case 'EEG'
                EEG = varvar{i};
                if class(EEG) ~= "struct"
                    error(['EEG data type is "struct", input is ',class(EEG)]); 
                end
                D = 0;
                dataf = true;
            otherwise
                error(['do not know input ',v]);
        end
    end

    % get file dir
    if ~Df && ~dataf % if no file and EEG
        D = dir(fullfile(filepath,'**','*.set'));
        if isempty(D)
            D = dir(fullfile(filepath));
        end
    end
    % ========================= main =================================
    % load event file
    evtTab = readtable(eventfile,"ReadRowNames",true);
    TabName = evtTab.Properties.VariableNames;
    if size(evtTab,1) ~= length(D), error('trial file has not same length with event trial'); end
    for ntrial = 1:length(D)
        EEG = pop_loadset(D(ntrial).name,D(ntrial).folder);
        for nevt = 1:length(EEG.event)
            for nvar = 1:length(TabName)
                EEG.event(nevt).(TabName{nvar}) = table2array(evtTab(ntrial,TabName{nvar}));
            end
        end
        pop_saveset(EEG,'filepath',D(ntrial).folder,'filename',D(ntrial).name);
    end
    % ================================================================
end

