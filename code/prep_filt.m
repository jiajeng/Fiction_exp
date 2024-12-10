function prep_filt(cutoffF,varargin)
    % input : 'filepath', "string", Get all .set file in this path
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
    
    % for every file
    fprintf('==========================================\n');
    fprintf('process %d files\n',length(D));
    fprintf('==========================================\n');
    for nfile = 1:length(D)
        fprintf('------------------------------------------\n');
        fprintf('start process ');
        msg = split(fullfile(D(nfile).folder,D(nfile).name),filesep);
        msg = strjoin(msg,[filesep,filesep,filesep]);
        cprintf('_cyan',msg);
        cprintf('white',' ... file\n')
        fprintf('------------------------------------------\n');
        % check outpath variable is exist or not (default outpath filepath/..)
        if ~dataf && ~opathf % if no EEG data and no outpath
            outpath = fullfile(D(nfile).folder,'..','prep');
        end

        if ~dataf % if no EEG
            % get EEG
            EEG = pop_loadset(D(nfile).name,D(nfile).folder);
        end
        % ----------------------- filt --------------------------
        EEG = pop_eegfiltnew(EEG, 'hicutoff',max(cutoffF));
        EEG = pop_eegfiltnew(EEG, 'locutoff',min(cutoffF));
        % notch filt to 60Hz
        EEG = pop_eegfiltnew(EEG, 'locutoff',59,'hicutoff',61,'revfilt',1);

        % create outpath
        if ~exist(outpath,'dir'), mkdir(outpath); end

        % save EEG .set file
        pop_saveset(EEG,'filename',['f',D(nfile).name],'filepath',outpath);
        % -------------------------------------------------------
    end
end