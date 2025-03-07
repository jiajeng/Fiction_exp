function stat1st_TFmap(eventpath,varargin)
    % input : 
    %       'eventpath', "string", eventfile dir
    %   
    % optional input data(choose one) : 
    %         'filepath', "string", Get all .set file in this path
    %         'file', "struct", fields contains folder and name, dir func output
    %         'EEG', "struct", eeglab pattern
    %       !! input data priority, EEG > file > filepath
    %         
    % optional input : 
    %         'outpath', "string", store .set file in this path, if not
    %                              enter, default is in
    %                              /./process/trial_21to22_TF(according to data path--> last folder in data path)
    %        
    %         'permute', "double", permutation times, default is 1000.
    opathf = false; 
    dataf = false;
    fbf = false;
    plotf = true;
    procf = true;

    % initial variable
    thres = 0.05;
    PERMUTE = 1000;
    srate = 1000;

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
            case 'thres'
                thres = varvar{i};
                if class(fBand) ~= "struct"
                    error(['fBand datat type is "struct", input type is ',class(thres)])
                end
            case 'plot'
                plotf = varvar{i};
                if class(plotf) ~= "logical" && class(plotf) ~= "double"
                    error(['plot data type is "logical" or "double", input type is ',class(plotf)])
                end
            case 'plot_channel'
                PLOTCHANNEL = varvar{i};
                if class(PLOTCHANNEL) ~= "cell"
                    error(['plot data type is "cell", input type is ',class(PLOTCHANNEL)])
                end
            case 'plot_subrow'
                SUBROW = varvar{i};
                if class(SUBROW) ~= "double"
                    error(['plot data type is "double", input type is ',class(SUBROW)])
                end
            case 'process'
                procf = varvar{i};
                if class(procf) ~= "logical" && class(procf) ~= "double"
                    error(['procf data type is "logical" or "double", input type is ',class(procf)])
                end
            case 'permute'
                PERMUTE = varvar{i};
                if class(PERMUTE) ~= "double"
                    error(['permute data type is "double", input type is ',class(PERMUTE)])
                end
            case 'DesignMatrix'
                DM = varvar{i};
                if class(DM) ~= "struct"
                    error(['DesignMatrix data type is "struct", input type is ',class(DM)])
                end
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
    end
    % set output path
    if ~opathf % if no set output path
        fold = split(D(1).folder,filesep);
        fold = fold{end};
        outpath = fullfile(D(1).folder,'..',[fold,'_stat'],'1st_level');
        figoutpath1 = fullfile(outpath,'heatmap');
        figoutpath2 = fullfile(outpath,'plot');
    end
    

    % ========================= main =================================
    if procf
        % -----------load all trial data 
        % READ frequency result --> BdPow and TFd --> need BdPow
        ALLDATA = struct();
        % ALLDATA.(channel) , 3-D matrix -- freq x times x trials 
        for nfile = 1:length(D)
            load(fullfile(D(nfile).folder,D(nfile).name),'BdPow','TFd');
            CHANNELNAME = BdPow.chname;
            for nch = 1:length(CHANNELNAME)
                % cat all EEG time frequency data
                ALLDATA.(CHANNELNAME{nch}) = cat(3,ALLDATA.(CHANNELNAME{nch}),abs(TFd.TFdata));
            end
        end % loop for all file(trials)
        % define number of some feature
        NFREQ = TFd.frq;
        NTRIAL = size(ALLDATA.(CHANNELNAME{nch}),3);
        NTIMES = size(ALLDATA.(CHANNELNAME{nch}),2);
        NCHANNEL = length(CHANNELNAME);

        % --------------- statistical ---------------------
        % ==== aim : using GLM to compute test ====
        % define data
        stat = struct();
        for nch = 1:NCHANNEL
            data = ALLDATA.(CHANNELNAME{nch}); % freq x times x trials
            if ~contains(fieldnames(stat),CHANNELNAME{nch}), stat.(CHANNELNAME{nch}) = []; end

            Y = squeeze(data(1,1,:));
            if ~exist("DM",'var') % one sample t
                X = ones(size(Y));% difference with zero
                Xname = {'Intercept'};
            elseif isempty(DM) % one sample t
                X = ones(size(Y));% difference with zero
                Xname = {'Intercept'};
            else
                X = [ones(size(Y)),DM.value];
                Xname = [{'Intercept'},DM.name];
            end
            beta = nan(NFREQ,NTIMES,length(Xname));
            tval = beta;

            for nf = 1:NFREQ
                for nt = 1:NTIMES
                    % ------ first level --> one sample t
                    % 1. Y = BX --> Y : EEG, X : disign matrix
                    MD = fitlm(X,Y,'Intercept',false);
                    % 2. get every point beta value and t value 
                    beta(nf,nt,:) = MD.Coefficients.Estimate;
                    tval(nf,nt,:) = MD.Coefficients.tStat;
                end
            end
            stat.(CHANNELNAME{nch}).name = Xname;
            stat.(CHANNELNAME{nch}).beta(nch,:,:) = beta; % freq x times x parameter
            stat.(CHANNELNAME{nch}).tval(nch,:,:) = tval; % freq x times
        end
        % -------------------------------------------------
    end % procf

    % ================================================================
end % function end

% define private function
function clu = getcluster2D(data)
    % input data is masked by some condition
    % input data type is logical or double that only contains 1 and 0
    % return cluster id in "clu"
    data = double(data);
    data(data==0) = nan;
    cluid = diff([ones(size(data,1),1),data],[],2);
    clu = zeros(size(data));

    for i = 1:size(cluid,1)
        id = 1;
        oj = 0;
        for j = 1:size(cluid,2)
            pt = cluid(i,j);
            if ~isnan(pt)
                if j-oj > 2 && oj ~= 0, id = id+1; end
                clu(i,j) = id;
                oj = j;
            end
        end
    end
end

function [pos_p,neg_p,pmask,nmask] = FDR_clu(t,p,threshold,dis,minclusDur)
    % p => 1*ntimes
    % dis ==> nperm*ntimes
    nperm = size(dis,1);
    maskp = p<threshold;
    dp = diff([0,maskp,0]); % 1 index onset, -1 index-1 offset
    onI = find(dp==1);
    offI = find(dp==-1)-1;
    mask = zeros(1,length(maskp));
    pos_p = zeros(1,length(onI));
    neg_p = pos_p;
    for i = 1:length(onI)
        if offI(i)-onI(i) < minclusDur
            continue;
        end
        mask(onI(i):offI(i)) = i;
        dis_max = max(dis(:,onI(i):offI(i)),[],2);
        dis_max = sort(dis_max);
        real_max = max(t(onI(i):offI(i)));
        dis_min = min(dis(:,onI(i):offI(i)),[],2);
        dis_min = sort(dis_min);
        real_min = min(t(onI(i):offI(i)));
        
        pos_p(i) = min(sum(dis_max>real_max)/nperm,sum(dis_max<real_max)/nperm);
        if pos_p(i) == 0, pos_p(i) = 10e-8;  end
        neg_p(i) = min(sum(dis_min>real_min)/nperm,sum(dis_min<real_min)/nperm);
        if neg_p(i) == 0, neg_p(i) = 10e-8;  end
    end
    pmask = mask;
    nmask = mask;
    for i = 1:length(pos_p)
        if pos_p(i)>threshold
            pmask(mask==i) = 0;
        end
        if neg_p(i)>threshold
            nmask(mask==i) = 0;
        end
    end

    % clus_size = offI-onI;
    % clus_sizep = clus_size>dis(ceil(round(length(dis)*(1-threshold))));
    % onI = onI(clus_sizep);
    % offI = offI(clus_sizep);
    % mask = zeros(1,length(t));
    % for i = 1:length(onI)
    %     mask(onI(i):offI(i)) = true;
    % end
end
