function prep_mergeFile(evtfile,varargin)
    % input :
    %    require 
    %       'eegtrlfile', "string", EEGtrialfile
    %    optional(1/3)
    %       'filepath', "string", Get all .set file in this path
    %         'file', "struct", fields contains folder and name, dir func output
    %         'EEG', "struct", eeglab pattern
    %       !! input data priority, EEG > file > filepath
    %
    %         'outpath', "string", store .set file in this path, if not
    %                              enter, default is in /./prep
    %         
    opathf = false;
    dataf = false;
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
    %% ---------------- main --------------------
    % get file dir
    if ~Df && ~dataf % if no file and EEG
        D = dir(fullfile(filepath,'**','*.set'));
        if isempty(D)
            D = dir(fullfile(filepath));
        end
    end
    % check outpath variable is exist or not (default outpath filepath/..)
    if ~dataf && ~opathf % if no EEG data and no outpath
        outpath = fullfile(D(1).folder,'..','RawMerg');
    end
    
    % read trial file
    tLtab = readtable(evtfile);
    eventname = {'Condition2','Condition3','Character'};

    % for every file
    fprintf('==========================================\n');
    fprintf('process %d files\n',length(D));
    fprintf('==========================================\n');
    EEG = pop_loadset(D(1).name,D(1).folder);
    for nfile = 2:length(D)
        EEG2 = pop_loadset(D(nfile).name,D(nfile).folder);
        EEG = pop_mergeset(EEG,EEG2);
    end
    % set event 
    idx = tLtab.number;
    for i = 1:length(eventname)
        for tbi = 1:length(idx)
            % check type is right
            if EEG.event(idx(tbi)).type ~= string(table2array(tLtab(tbi,"type"))) || EEG.event(idx(tbi)).latency ~= table2array(tLtab(tbi,"latency"))
                error('check event list');
            end
            EEG.event(idx(tbi)).(eventname{i}) = table2array(tLtab(tbi,eventname{i}));
            EEG.event(idx(tbi)-3).(eventname{i}) = table2array(tLtab(tbi,eventname{i})); %21
            EEG.event(idx(tbi)-2).(eventname{i}) = table2array(tLtab(tbi,eventname{i})); %22
        end
    end
    if ~exist(outpath,'dir'),mkdir(outpath); end
    pop_saveset(EEG,'filename',D(1).name,'filepath',outpath);
end