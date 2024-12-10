function epoch_Data(sttype,edtype,varargin)
    % input : 'sttype', "string", start event type
    %         'edtype', "string", end event type
    %         'filepath', "string", Get all .set file in this path
    %         'file', "struct", fields contains folder and name, dir func output
    %         'EEG', "struct", eeglab pattern
    %       !! input data priority, EEG > file > filepath
    %
    %         'outpath', "string", store .set file in this path, if not
    %                              enter, default is in
    %                              ./process/trial_21to22('sttype'to'edtype')
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
    % initial var
    trialnum = 0;

    fprintf('==========================================\n');
    fprintf('process %d files\n',length(D));
    fprintf('==========================================\n');
    % for every file
    for nfile = 1:length(D)
        fprintf('------------------------------------------\n');
        fprintf('start process ');
        msg = fullfile(D(nfile).folder,D(nfile).name);
        msg = split(msg,filesep);
        msg = char(strjoin(msg,[filesep,filesep,filesep]));
        cprintf('_cyan',msg);
        cprintf('white',' ... file\n')
        fprintf('------------------------------------------\n');
        % check outpath variable is exist or not (default outpath filepath/..)
        if ~dataf && ~opathf % if no EEG data and no outpath
            outpath = fullfile(D(nfile).folder,'..','process',['trials_',num2str(sttype),'to',num2str(edtype)]);
        end

        if ~dataf % if no EEG
            % get EEG
            EEG = pop_loadset(D(nfile).name,D(nfile).folder);
        end

        % ---------------------- epoch ---------------------------- 
        % get epoch point idx
        evttype = {EEG.event.type};
        evtlant = [EEG.event.latency];
        stid = find(contains(evttype,sttype));
        edid = find(contains(evttype,edtype));
        stlant = evtlant(stid);
        edlant = evtlant(edid);

        if length(stid) ~= length(edid)
            addL = abs(length(stid)-length(edid));
            for i = 1:addL
                if length(stlant) > length(edlant)
                    edid = cat(2,edid,zeros(1,addL));
                else
                    stid = cat(2,stid,zeros(1,addL));
                end
                tmp = edid - stid;
                tmp = find(tmp~=1);
                if stid(end)==0
                    stid(end-addL+1:end) = [];
                    edid(tmp(1)) = [];
                else
                    edid(end-addL+1:end) = [];
                    stid(tmp(1)) = [];
                end
                addL = addL-1;
            end
            stlant = evtlant(stid);
            edlant = evtlant(edid);
        end

        % create outpath
        if ~exist(outpath,'dir'), mkdir(outpath); end
        for i = 1:length(stlant)
            eEEG = pop_select( EEG, 'point', [stlant(i),edlant(i)]);
            pop_saveset(eEEG,'filename',['t',num2str(i+trialnum),'_',D(nfile).name],'filepath',outpath);
        end
        trialnum = trialnum+length(stlant);
        % -------------------------------------------------------
    end
end