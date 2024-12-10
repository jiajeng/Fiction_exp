function prep_ICA(varargin)
    % input : 'filepath', "string", Get all .set file in this path
    %         'file', "struct", fields contains folder and name, dir func output
    %         'EEG', "struct", eeglab pattern
    %       !! input data priority, EEG > file > filepath
    %
    %         'outpath', "string", store .set file in this path, if not
    %                              enter, default is in ./perp
    %         
    opathf = false;
    dataf = false;
    typef = false;
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
            case 'icatype'
                icatype = varvar{i};
                if class(outpath) ~= "string" && class(outpath) ~= "char"
                    error(['criterion data type is "double", input is ',class(icatype)])
                end
                typef = true;
            otherwise
                error(['do not know input ',v]);
        end
    end

    % initial 
    if ~typef, icatype = 'runica'; end

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

        % ---------------------- ICA ---------------------------
        % create outpath
        if ~exist(outpath,'dir'), mkdir(outpath); end

        % ICA
        if icatype == "runica"
            EEG = pop_runica(EEG, 'icatype', icatype, 'extended',1,'interrupt','on');
        else
            EEG = pop_runica(EEG, 'icatype', icatype);
        end
        % save EEG .set file
        pop_saveset(EEG,'filename',['i',D(nfile).name],'filepath',outpath);
        % ------------------------------------------------------

        % ---------------------- remove component ---------------------------- 
        % remove ICA component----get EEG ICA label
        EEG = pop_iclabel(EEG, 'default');
        pop_viewprops(EEG,0,[1:size(EEG.icaact,1)]);
        ICA_comp_fig_output_name = [D(nfile).name,'_icClass.jpeg'];

        % save fig
        saveas(gcf,fullfile(outpath,ICA_comp_fig_output_name));

        close gcf;

        icaclassification = EEG.etc.ic_classification.ICLabel.classifications;
        icalabel = EEG.etc.ic_classification.ICLabel.classes;
        icalabelcont = [];
        
        % remove ICA component----find each component classification label
        for i = 1:size(icaclassification,1)
            labelindex = find(icaclassification(i,:)==max(icaclassification(i,:)));
            labelpercent = icaclassification(i,labelindex);
            icalabelcont(i,1) = labelindex;
            icalabelcont(i,2) = labelpercent;
            %ilabelpercent = cat(1,ilabelpercent,labelpercent);
        end
    
        % remove ICA component-----get component number except brian
        % and other | find the component greater than 90%
        icalabelcont = array2table(icalabelcont);
        icalabelcont.Properties.VariableNames = {'index','probability'};
        icalabelcont.index = icalabel(icalabelcont.index)';
        % Brainindex = find(ismember(icalabelcont.index,"Brain"));
        % find_sub_com = find(icalabelcont.probability>0.9);
        % find_sub_com = find_sub_com(find(~ismember(find_sub_com,Brainindex)));
        icaCom_label = convertCharsToStrings(icalabelcont.index);
        find_sub_com = ismember(icaCom_label,"Brain")+ismember(icaCom_label,"Other"); %except the Brain and other need remove
        find_sub_com = find(~find_sub_com);
        EEG =pop_subcomp( EEG, find_sub_com, 0);

        % save EEG .set file
        pop_saveset(EEG,'filename',['ri',D(nfile).name],'filepath',outpath);
        % -------------------------------------------------------



    end
end