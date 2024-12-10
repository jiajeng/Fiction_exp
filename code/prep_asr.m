function prep_asr(varargin)
    % input : 'filepath', "string", Get all .set file in this path
    %         'file', "struct", fields contains folder and name, dir func output
    %         'EEG', "struct", eeglab pattern
    %       !! input data priority, EEG > file > filepath
    %         'criterion', "real", ASR criterion, defalt is 20
    %
    %         'outpath', "string", store .set file in this path, if not
    %                              enter, default is in ./perp
    %         
    opathf = false;
    dataf = false;
    crif = false;
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
            case 'criterion'
                crite = varvar{i};
                if class(crite) ~= "double"
                    error(['criterion data type is "double", input is ',class(crite)])
                end
                crif = true;
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
    end
    
    fprintf('==========================================\n');
    fprintf('process %d files\n',length(D));
    fprintf('==========================================\n');
    % for every file
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

        % ---------------------- ASR ---------------------------- 
        EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion',crite,'WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
        % create outpath
        if ~exist(outpath,'dir'), mkdir(outpath); end
        
        pop_saveset(EEG,'filename',['a',D(nfile).name],'filepath',outpath);
        % -------------------------------------------------------


   
    end
end