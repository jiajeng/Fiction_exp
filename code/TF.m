function TF(varargin)
    % input data : 
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
    % loop for file
    butData = struct(); % a buffer variable to butterfly plot
    for nfile = 1:length(D)
        % set output path
        if ~opathf % if no set output path
            fold = split(D(nfile).folder,filesep);
            fold = fold{end};
            outpath = fullfile(D(nfile).folder,'..',[fold,'_TF']);
            figoutpath_Htmp = fullfile(outpath,'Heatmap');
            figoutpath_butr = fullfile(outpath,'butterfly');
        end

        outname = split(D(nfile).name,'.');
        outname = outname{1};
        if procf
            % ------------ transfer to frequency -----------
            if ~dataf % if no EEG then read file
                EEG = pop_loadset(D(nfile).name,D(nfile).folder);
            end
            chname = {EEG.chanlocs.labels};
            TFd = struct();
            BdPow = struct(); % BdPow."fbname" =  channel x times 
            for nfb = 1:length(fBname)
                BdPow.(fBname{nfb}) = [];
                BdPow.chname = chname;
            end

            % save eeg potential data
            eegPotnData = EEG.data(:,end-5000:end);
            
            for nch = 1:length(chname)
                % wavelet transform
                [cfs,frq] = cwt(EEG.data(nch,end-5000:end),EEG.srate);
                
                % time
                tms = (0:numel(EEG.data(nch,end-5000:end))-1)/EEG.srate;
                % only need below 30 Hz
                Fidx = frq<31;
                cfs = cfs(Fidx,:);
                frq = frq(Fidx);
                % store result data
                TFd.(chname{nch}).Tfdata = cfs;
                TFd.(chname{nch}).time = tms;
                TFd.(chname{nch}).frq = frq;
    
                % calculate frequency band data
                for nfb = 1:length(fBname)
                    band = fBand.(fBname{nfb});
                    TFd.(chname{nch}).([fBname{nfb}]) = cfs(min(band) < frq & frq < max(band),:);
                    % average Band Power
                    tmp = mean(abs(cfs(min(band) < frq & frq < max(band),:)),1);
                    BdPow.(fBname{nfb}) = cat(1,BdPow.(fBname{nfb}),tmp);
                end
            end
           
            TFd.freqBand = struct2table(fBand);
            % save variable
            if ~exist(outpath,'dir'), mkdir(outpath); end
            save(fullfile(outpath,[outname,'.mat']),"TFd","BdPow","eegPotnData")
            % -------------------------------------------------
        end % proc flag

        if plotf
            if ~procf 
                % load output file in this script
                load(fullfile(outpath,[outname,'.mat']))
                chname = BdPow.chname;
                tms = TFd.(chname{1}).time;
            end
            % plot Band power of all electrodes(heatmap)
            CH_PLOT_IDX = cellfun(@(x) find(string(x)==string(chname)),CH_PLOT_ORDER);
            for nfb = 1:length(fBname)
                % plot heatmap
                figure;
                Xdlabel = NaN(1,length(tms));
                for i = 0:5
                    Xdlabel(tms==i) = tms(tms==i);
                end
                heatmap(BdPow.(fBname{nfb})(CH_PLOT_IDX,:),'GridVisible','off','Colormap',jet,'XDisplayLabels',Xdlabel,'YDisplayLabels',CH_PLOT_ORDER);
                title(fBname{nfb})
                fboutpath = fullfile(figoutpath_Htmp,fBname{nfb});
                if ~exist(fboutpath,'dir'),mkdir(fboutpath); end
                saveas(gcf,fullfile(fboutpath,[outname,'_',fBname{nfb},'.jpeg']));
                close(gcf);
        
                % plot butterfly(all trial in one plot) in every electrodes
                % cat all file data
                fndf = contains(string(fieldnames(butData)),fBname{nfb});
                if ~fndf
                    butData.(fBname{nfb}) = [];
                elseif isempty(fndf)
                    butData.(fBname{nfb}) = [];
                end
                butData.(fBname{nfb}) = cat(3,butData.(fBname{nfb}),BdPow.(fBname{nfb}));

                % when file loop for last one then plot 
                if nfile == length(D)
                    for nch = 1:length(chname)
                        figure;
                        plot(tms,squeeze(butData.(fBname{nfb})(nch,:,:))','Color','k');
                        title(chname{nch});
                        xlabel('time (s)','FontWeight','bold')
                        ylabel('Power','FontWeight','bold')
                        if ~exist(figoutpath_butr,'dir'), mkdir(figoutpath_butr); end
                        saveas(gcf,fullfile(figoutpath_butr,[fBname{i},'_',chname{nch},'.jpeg']));
                        close(gcf);
                    end
                end

            end
        end % plot flag
    end % file loop
    % ================================================================
end

