function [varargout] = avrRdTime(varargin)
    % input : 'filepath', "string", Get all .set file in this path
    %         'file', "struct", fields contains folder and name, dir func output
    %         'EEG', "struct", eeglab pattern
    %       !! input data priority, EEG > file > filepath
    %
    %         'outpath', "string", store .set file in this path, if not
    %                              enter, default is in setfile/process/RdTime.mat
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

    % get file dir
    if ~Df && ~dataf % if no file and EEG
        D = dir(fullfile(filepath,'**','*.set'));
        if isempty(D)
            D = dir(fullfile(filepath));
        end
    else
        D = 0;
    end
    RdTime = cell(length(D),1);
    % check outpath variable is exist or not (default outpath filepath/..)
    if ~dataf && ~opathf % if no EEG data and no outpath
        outpath = fullfile(D(end).folder,'..');
    end

    for nfile = 1:length(D)
        fprintf('------------------------------------------\n');
        fprintf('start process ');
        msg = split(fullfile(D(nfile).folder,D(nfile).name),filesep);
        msg = strjoin(msg,[filesep,filesep,filesep]);
        cprintf('_cyan',msg);
        cprintf('white',' ... file\n')
        fprintf('------------------------------------------\n');
        % read EEG
        if ~dataf % if no EEG
            % get EEG
            EEG = pop_loadset(D(nfile).name,D(nfile).folder);
        end
        
        % create outpath
        if ~exist(outpath,'dir'), mkdir(outpath); end
        % ------------------create output table-----------------
        RdTime{nfile} = EEG.pnts/EEG.srate; % unit s
        % ------------------------------------------------------
    end
    save(fullfile(outpath,'RdTime.mat'),"RdTime");
    if nargout == 1
        varargout{1} = struct2table(RdTime);
    end
end