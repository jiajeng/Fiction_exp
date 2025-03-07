function spec_Data(varargin)
    % input : 'filepath', "string", Get all .set file in this path
    %         'file', "struct", fields contains folder and name, dir func output
    %         'EEG', "struct", eeglab pattern
    %       !! input data priority, EEG > file > filepath
    %         'criterion', "real", ASR criterion, defalt is 20
    %
    %         'outpath', "string", store .set file in this path, if not
    %                              enter, default is in setfile/../perp
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
                dataf = true;
            otherwise
                error(['do not know input ',v]);
        end
    end
    % initial default
    if ~crif, crite = 20;end
    %% ---------------- main --------------------
    % get file dir
    if ~Df && ~dataf % if no file and EEG
        D = dir(fullfile(filepath,'**','*.set'));
        if isempty(D)
            D = dir(fullfile(filepath));
        end
    else
        D = 0;
    end
    
    fprintf('==========================================\n');
    fprintf('process %d files\n',length(D));
    fprintf('==========================================\n');
    % for every file
    for nfile = 1:length(D)
        fprintf('------------------------------------------\n');
        fprintf('start process ');
        cprintf('_cyan',fullfile(D(nfile).folder,D(nfile).name));
        cprintf('white',' ... file\n')
        fprintf('------------------------------------------\n');
        % check outpath variable is exist or not (default outpath filepath/..)
        if ~dataf && ~opathf % if no EEG data and no outpath
            outpath = fullfile(D(nfile).folder,'..','process','spectrum');
        end

        if ~dataf % if no EEG
            % get EEG
            EEG = pop_loadset(D(nfile).name,D(nfile).folder);
        end
        % ---------------------- get spectrum ---------------------------- 
        Data = EEG.data;
        Y = fft(Data);
        [pxx,f] = pwelch(Y,EEG.srate,[],EEG.srate);
        figure;
        plot(f,pxx);

        pop_saveset(EEG,'filename',['spec_',D(nfile).name],'filepath',outpath);
        % ----------------------------------------------------------------
    end
end