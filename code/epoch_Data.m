function epoch_Data(sttype,edtype,eventfile,varargin)
    % input : 
    % require
    %         'sttype', "string", start event type
    %         'edtype', "string", end event type
    %         'eventfile', "string", eventfile path and filename
    %         'eegTrialfile', "string", contains which trial is needed,
    %                       like eeglab .set file event table,
    %                       (need number this comlum --> index
    % optional 1/3
    %         'filepath', "string", Get all .set file in this path
    %         'file', "struct", fields contains folder and name, dir func output
    %         'EEG', "struct", eeglab pattern
    %       !! input data priority, EEG > file > filepath
    % optional
    %         'outpath', "string", store .set file in this path, if not
    %                              enter, default is in
    %                              ./process/trial_21to22('sttype'to'edtype')
    %         
    opathf = false;
    dataf = false;
    durf = false;
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
            case 'get_dur_time'
                durf = varvar{i};
                if class(durf) ~= "logical" && class(durf) ~= "double"
                    error(['durf data type is "logical", input is ',class(durf)]); 
                end
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
    durTime = [];
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
 
        % check all type 22 index - type 31 index is -1
        dif = unique(edid - find(contains(evttype,'31')));
        if length(dif)>1,disp('type 22 - type 31 index is not -1'); keyboard; end
    
        % if start idx length is not equal to end idx
        % 1. find extra idx number 
        % 2. for loop for extra number 
        %   (add zeros to short idarray, if stid is longer than add zeros to edid)
        % 3. minus two id array (stid - edid)
        % 4. for same story edid - stid should be 1
        % 5. find edid - stid not be 1 
        %   (find which id array is longer)
        % 6. remove shoter array end zeros 
        %    remove longer array idx that edid-stid not equal to 1
        if length(stid) ~= length(edid)
            addL = abs(length(stid)-length(edid));
            for i = 1:addL
                if length(stid) > length(edid)
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
        end
        
        % read trial event file
        evtTab = readtable(eventfile);
        cond = evtTab.Condition2;
        idx = evtTab.number;
        idx(cond==99) = [];
        trialedidx = idx+dif; % 31-->22
        [~,Lorder] = sort(evtTab.latency);

        % check EEG latency is same as table number
        if any(evtlant(idx)'-evtTab.latency), disp('check event table latency and EEG latecy is same'); keyboard; end

        % find delete trial id then apply to start idx and end idx
        deltrial = cellfun(@isempty,arrayfun(@(x) find(trialedidx==(x)),edid,'UniformOutput',false));
        edid(deltrial) = [];
        stid(deltrial) = [];

        id = table2array(evtTab(:,1));
        
        % define start lantency and end latency value 
        stlant = evtlant(stid);
        edlant = evtlant(edid);

        % create outpath
        if ~exist(outpath,'dir'), mkdir(outpath); end
        for i = 1:length(id)
            Tn = Lorder(i);
            eEEG = pop_select( EEG, 'point', [stlant(i),edlant(i)]);
            evtTab.dur(Tn+trialnum) = eEEG.pnts/eEEG.srate;
            pop_saveset(eEEG,'filename',['t',num2str(id(Tn+trialnum)),'_',D(nfile).name],'filepath',outpath);
        end
        trialnum = trialnum+length(stlant);
        % -------------------------------------------------------
    end % nfile
    writetable(evtTab,eventfile);
    if durf
        durTime = evtTab.dur;
        writematrix(durTime,fullfile(outpath,'..','durTime.csv'));
    end
end