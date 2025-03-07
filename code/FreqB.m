function FreqB(varargin)
    % input data : 
    %       require : 
    %         'entime', "double", data point that before in the end of data epoch 
    %       optional 1/3
    %         'filepath', "string", Get all .set file in this path
    %         'file', "struct", fields contains folder and name, dir func output
    %         'EEG', "struct", eeglab pattern
    %       !! input data priority, EEG > file > filepath
    %         
    %       optional
    %         'outpath', "string", store .set file in this path, if not
    %                              enter, default is in
    %                              /./process/trial_21to22_TF(according to data path--> last folder in data path)
    %       optional
    %         'freqBand', "struct", fieldnames is band name, contains min
    %                               and max value of limit of this freq band. 
    %                               Default is freqBand.delta = [1,4]
    %                                          freqBand.theta = [4,8]
    %                                          freqBand.alpha = [8,12]
    %                                          freqBand.beta = [12,30]
    opathf = false;
    dataf = false;
    plotf = true;
    procf = true;
    % initial variable
    fBand.delta = [1,4]';
    fBand.theta = [4,8]';
    fBand.alpha = [8,12]';
    fBand.beta = [12,30]';
    fBname = fieldnames(fBand);

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
            case 'freqBand'
                fBand = varvar{i};
                fBname = fieldnames(fBand);
                if class(fBand) ~= "struct"
                    error(['fBand datat type is "struct", input type is ',class(fBand)])
                end
            case 'plot'
                plotf = varvar{i};
                if class(plotf) ~= "logical" && class(plotf) ~= "double"
                    error(['plot data type is "logical" or "double", input type is ',class(plotf)])
                end
            case 'process'
                procf = varvar{i};
                if class(procf) ~= "logical" && class(procf) ~= "double"
                    error(['procf data type is "logical" or "double", input type is ',class(procf)])
                end
            otherwise
                error(['do not know input ',v]);
        end
    end

    CH_PLOT_ORDER = {'Fp1','Fp2', ...
                'F7','F3','Fz','F4','F8',...
                 'FC5','FC1','FC2','FC6','FT10',...
                'T7','C3','Cz','C4','T8',...
          'TP9','CP5','CP1','CP2','CP6','TP10',...
                'P7','P3','Pz','P4','P8',...
                     'O1','Oz','O2'};
    % get file dir
    if ~Df && ~dataf % if no file and EEG
        D = dir(fullfile(filepath,'**','*.set'));
        if isempty(D)
            D = dir(fullfile(filepath));
        end
    end
    
    
    % ========================= main =================================

    for nfile = 1:length(D)
        res = struct();
        % set output path and name
        if ~opathf % if no set output path
            fold = split(D(nfile).folder,filesep);
            fold = fold{end};
            outpath = fullfile(D(nfile).folder,'..',['Freq_',fold]);
        end
        outname = split(D(nfile).name,'.');
        outname = outname{1};

        % get EEG 
        if ~dataf % if no EEG then read file
            EEG = pop_loadset(D(nfile).name,D(nfile).folder);
        end
        data = EEG.data;
        
        % set variable
        CHANNELNAME = {EEG.chanlocs.labels};
        fs = EEG.srate;

        % cut data to three part
        intv = round(EEG.pnts/3);
        
        for i = 1:3
            % get data idx
            if i ~= 3
                idx = 1+intv*(i-1):intv+intv*(i-1);
            else
                idx = 1+intv*(i-1):EEG.pnts;
            end
            
            % get data frequency
            X = fft(data(:,idx),[],2);
            X = X(:,ceil(1:length(X)/2));
            pxx = (1/(2*pi*length(X)))*abs(X).^2;
            f = linspace(0,fs/2,length(pxx));
            pxx(:,f>50) = [];
            f(f>50) = [];

            for chi = 1:length(CHANNELNAME)
                res.(CHANNELNAME{chi}).(['par_',num2str(i)]).('power') = pxx(chi,:);
                res.(CHANNELNAME{chi}).(['par_',num2str(i)]).('f') = f;
                % get freqeuncy band 
                for nfb = 1:length(fBname)
                    fb = fBand.(fBname{nfb});
                    fbf = f>=fb(1) & f<fb(2);
                    % absolute band power 
                    res.(CHANNELNAME{chi}).(['par_',num2str(i)]).absBand.(fBname{nfb}) = bandpower(pxx(chi,fbf),f(fbf),"psd");
                    % relative band power, Denominator is min to max frequency band
                    flim = [min(struct2array(fBand),[],'all'),max(struct2array(fBand),[],'all')];
                    flimidx = f>flim(1) & f<flim(2);
                    res.(CHANNELNAME{chi}).(['par_',num2str(i)]).relBand.(fBname{nfb}) = bandpower(pxx(chi,fbf),f(fbf),"psd")/bandpower(pxx(chi,flimidx),f(flimidx),"psd");
                end
            end
        end
        % save res variable
        if ~exist(outpath,'dir'), mkdir(outpath); end
        save(fullfile(outpath,['f',outname,'.mat']),"res");
    end
    % ================================================================
end

