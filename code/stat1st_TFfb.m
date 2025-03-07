function stat1st_TFfB(eventpath,varargin)
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
        outpath = fullfile(D(1).folder,'..',[fold,'_stat'],'1st_level_FB');
        figoutpath1 = fullfile(outpath,'heatmap');
        figoutpath2 = fullfile(outpath,'plot');
    end
    

    % ========================= main =================================
    if procf
        % -----------get event tab 
        evtTab = readtable(eventpath,'ReadRowNames',true);
        emtype = string(evtTab.Story);
        tmp = unique(emtype);
        if length(tmp) > 2, error('event type is more than two, expect positive and negative'); end
        % get positive type
        tmp = tmp(contains(tmp,'P') | contains(tmp,'p'));
        emidx = emtype == tmp;

        % -----------load all trial data 
        % READ frequency result --> BdPow and TFd --> need BdPow
        ALLDATA = struct();
        ALLEEGTRIAL = [];
        % ALLDATA.(Band name) , 3-D matrix -- channel x times x trials 
        % ALLEEGTRIAL, 3-D matrix -- channel x times x trials
        for nfile = 1:length(D)
            load(fullfile(D(nfile).folder,D(nfile).name),'BdPow','eegPotnData');
            fBname = fieldnames(BdPow);
            CHANNELNAME = BdPow.chname;
            fBname = fBname(~contains(string(fBname),'chname'));
            % cat all EEG trial frequency Band data
            for nFB = 1:length(fBname)
                fdnf = contains(string(fieldnames(ALLDATA)),fBname{nFB});
                if isempty(fdnf)
                    ALLDATA.(fBname{nFB}) = [];
                elseif ~fdnf
                    ALLDATA.(fBname{nFB}) = [];
                end
                ALLDATA.(fBname{nFB}) = cat(3,ALLDATA.(fBname{nFB}),BdPow.(fBname{nFB}));
            end
            % cat all EEG trial potential data
            ALLEEGTRIAL = cat(3,ALLEEGTRIAL,eegPotnData);
        end % loop for all file(trials)

        % define number of some feature
        NTRIAL = size(ALLEEGTRIAL,3);
        NTIMES = size(ALLEEGTRIAL,2);
        NCHANNEL = size(ALLEEGTRIAL,1);

        % % --------------- statistical ---------------------
        % % ===== aim : positive story v.s negitive story ====
        % % 1.(real) get two condition
        % % 2.(real) compute two sample t test 
        % % 3.(real) pool all condition together 
        % % 4.(perm) random get half to one coniditon and the other is another conidtion
        % % 5.(perm) repeat 4. to 1000(set for user) times
        % % 6.(real) set a threshold to t value (p = 0.05 using "tinv" function to get t thres)
        % % 7.(real) set 6. threshold to 2. result
        % % 8.(real) get cluster in 7.
        % % 9.(real) sum each cluster t value in 8.
        % % 10.(perm & real) using real cluster index to sum each perm t value
        % % 11.(perm) find the max perm t value across all perm
        % % 12.(perm) the perm distribution that contains max perm is the null hypothesis distribution
        % % 13.(real & perm) using null hypothesis distribution and real data to get p value
        % % 14.(real) ~~~~get cluster-base correction result~~~
        % 
        % % -----------get t value (P-N)
        % stat = struct();
        % for nFB = 1:length(fBname)
        %     data3D = ALLDATA.(fBname{nFB}); % channel x time x trials
        %     % initial Tstat struct
        %     fdnf = contains(string(fieldnames(stat)),fBname{nFB});
        %     if ~fdnf
        %         stat.(fBname{nFB}) = [];
        %     elseif isempty(fdnf)
        %         stat.(fBname{nFB}) = [];
        %     end
        % 
        %     % loop for time point
        %     Tval = []; % channel x times
        %     for nt = 1:NTIMES
        %         % H = uP ~= uN
        %         % get t value
        %         data2D = squeeze(data3D(:,nt,:)); % channel x trials
        %         Pdata2D = data2D(:,emidx); % positive data
        %         Ndata2D = data2D(:,~emidx); % negative data
        %         [~,~,~,stats] = ttest2(Pdata2D',Ndata2D');
        %         Tval = cat(2,Tval,stats.tstat');
        %     end % loop for time point
        %     stat.(fBname{nFB}).Tval = Tval;
        % 
        %     % ----------- permutation 
        %     Tperm = nan(NCHANNEL,NTIMES,PERMUTE); % channel x times x permutation
        %     gcp;
        %     parfor npar = 1:PERMUTE
        %         ALLdata = data3D;
        %          % channel x times
        %         for nt = 1:NTIMES
        %             data2D = squeeze(ALLdata(:,nt,:)); % channel x trials
        %             idx = false(NTRIAL,1);
        %             idx(randperm(NTRIAL,NTRIAL/2)) = true;
        %             Pdata2D = data2D(:,idx);
        %             Ndata2D = data2D(:,~idx);
        %             [~,~,~,stats] = ttest2(Pdata2D',Ndata2D');
        %             Tperm(:,nt,npar) = stats.tstat;
        %         end
        %     end
        %     delete(gcp);
        % 
        %     % ----------- get cluster 
        %     RTval = stat.(fBname{nFB}).Tval; % channel x times
        %     % Real data cluster
        %     thresT = abs(tinv(thres/2,NTRIAL-2));
        %     mask = abs(stat.(fBname{nFB}).Tval) > thresT; % two tail
        %     Rclu = getcluster2D(mask); % 
        % 
        %     % loop for channels
        %     Pval = zeros(size(RTval));
        %     for npch = 1:NCHANNEL
        %         clu = Rclu(npch,:);
        %         cluid = unique(clu);
        %         cluid(cluid == 0) = [];
        %         rtval = [];
        %         permD = [];
        %         for nclu = 1:length(cluid)
        %             cluidx = clu == cluid(nclu);
        %             % get cluster index real t value
        %             rtval = cat(2,rtval,sum(abs(RTval(npch,cluidx))));
        %             % get cluster index permutation t value
        %             permD = cat(2,permD,squeeze(sum(abs(Tperm(npch,cluidx,:)),2)));
        %         end
        %         [~,max_cluperm] = max(max(permD));
        %         permD = permD(:,max_cluperm);
        % 
        %         for nclu = 1:length(cluid)
        %             cluidx = clu == cluid(nclu);
        %             p = sum(permD>rtval(nclu))/PERMUTE;
        %             if p == 0, p = 0.00000001; end
        %             Pval(npch,cluidx) = p;
        %         end
        %     end
        %     stat.(fBname{nFB}).cluPval = Pval; % ncahnnel x times
        % end % loop for freq band
        % 
        % stat.permTimes = PERMUTE;
        % stat.thresP = thres;
        % stat.thresT = thresT;
        % % save variables
        % if ~exist(outpath,'dir'), mkdir(outpath); end 
        % save(fullfile(outpath,'stat.mat'),"stat");
        % 
        % % -------------------------------------------------

        % --------------- statistical ---------------------
        % ==== aim : using GLM to compute test ====
        for nfb = 1:length(fBname)
            % define data
            data = ALLDATA.(fBname{nFB}); % channel x times x trials
            stat = struct();
            if ~contains(fieldnames(stat),fBname{nFB}), stat.(fBname{nFB}) = []; end
            for nch = 1:NCHANNEL
                Y = squeeze(data(nch,1,:));
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
                beta = nan(NTIMES,length(Xname));
                tval = beta;
                for nt = 1:NTIMES
                    % ------ first level --> one sample t
                    % 1. Y = BX --> Y : EEG, X : disign matrix
                    Y = squeeze(data(nch,nt,:));
                   
                    MD = fitlm(X,Y,'Intercept',false);
                    % 2. get every point beta value and t value 
                    beta(nt,:) = MD.Coefficients.Estimate';
                    tval(nt,:) = MD.Coefficients.tStat';
                end
                stat.(fBname{nFB}).name = Xname;
                stat.(fBname{nFB}).beta(nch,:,:) = beta; % channel x times x parameter
                stat.(fBname{nFB}).tval(nch,:,:) = tval; % channel x times
            end
        end
        if ~exist(outpath,'dir'), mkdir(outpath); end
        save(fullfile(outpath,'stat.mat'),"stat");
        % -------------------------------------------------
    end % procf

    if plotf
        % initial PLOT_CHANNEL ORDER
        if ~exist("PLOTCHANNEL",'var')
            PLOTCHANNEL = {'','Fp1','','Fp2','' ...
                       ,'F7','F3','tem','F4','F8'...
                       ,'FC5','FC1','','FC2','FC6' ...
                       ,'T7','C3','Cz','C4','T8' ...
                       ,'CP5','CP1','','CP2','CP6'...
                       ,'P7','P3','Pz','P4','P8' ...
                       ,'','O1','Oz','O2',''}; % for 32 channel
        end
        if ~exist("PLOTCHANNELROWN",'var')
            SUBROW = 5;
        end
        SUBCOL = length(PLOTCHANNEL)/SUBROW;
        % plot heatmap for all frequency band 
        % load file 
        if ~procf
            load(fullfile(outpath,'stat.mat'));
            load(fullfile(D(1).folder,D(1).name),'BdPow');
            fBname = fieldnames(BdPow);
            fBname = fBname(~contains(fBname,'chname'));
            CHANNELNAME = BdPow.chname;
            tms = (0:numel(1:size(BdPow.(fBname{1}),2))-1)/srate;
        end
        % check plotchannel variable
        tmp = PLOTCHANNEL(~cellfun(@isempty, PLOTCHANNEL));
        for i = 1:length(tmp)
            c = string(tmp{i});
            if ~contains(string(CHANNELNAME),c) 
                if c~="tem"
                    warning('input plot channel order contains not known channel %s ',c)
                end
            end
        end

        for nFB = 1:length(fBname)
            % heatmap
            data = stat.(fBname{nFB}).cluPval;
            data(data==0 | data>thres) = nan;
            figure;
            Xdlabel = NaN(1,length(tms));
            for i = 0:max(tms)
                Xdlabel(tms==i) = tms(tms==i);
            end
            heatmap(data,'GridVisible','off','Colormap',flip(hot),'XDisplayLabels',Xdlabel,'YDisplayLabels',CHANNELNAME);
            title(fBname{nFB});
            clim([0,1])
            if ~exist(figoutpath1,'dir'), mkdir(figoutpath1); end
            saveas(gcf,fullfile(figoutpath1,[fBname{nFB},'_p.jpeg']));
            close(gcf)

            % allchannel plot
            data = BdPow.(fBname{nFB});
            data_pv = stat.(fBname{nFB}).cluPval;
            figure(1);
            set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
            ylimt = [min(data,[],"all"),max(data,[],"all")];
            for npch = 1:length(PLOTCHANNEL)
                Pch = PLOTCHANNEL{npch}; % plot channel name 
                if ~isempty(Pch)
                    nch = contains(CHANNELNAME,Pch); % real channel name == plot channel name --> index
                else
                    continue;
                end
                if any(nch) 
                    % plot line 
                    subplot(SUBCOL,SUBROW,npch);
                    plot(tms,data(nch,:));
                    ylim(ylimt);
                    title(CHANNELNAME{nch})
                    % plot significant
                    pv = logical(data_pv(nch,:));
                    pv = diff([0,pv,0]);
                    pat_x = [tms(pv==1);tms(find(pv==-1)-1)];
                    pat_x = [pat_x;flip(pat_x)];
                    pat_y = repmat(reshape(repmat(ylimt,2,1),[],1),1,size(pat_x,2)); 
                    patch(pat_x',pat_y',[100,100,100]/256,'FaceAlpha',0.3,'EdgeColor','none');
                end
                if Pch == "tem"
                    subplot(SUBCOL,SUBROW,npch);
                    text(mean([min(tms), max(tms)]),mean(ylimt),0,fBname{nFB},'fontSize',30,'HorizontalAlignment','center','FontWeight','bold')
                    set(gca, 'Color', 'None');
                    ylim(ylimt)
                    xlim([min(tms), max(tms)])
                    ylabel('Power','FontWeight','bold','FontSize',13);
                    xlabel('time (s)','FontWeight','bold','FontSize',13);
                end
            end % npch 
        end% nFB
        if ~exist(figoutpath2,'dir'), mkdir(figoutpath2); end
        saveas(gcf,fullfile(figoutpath2,[fBname{nFB},'.jpeg']));
        close(gcf)
    end
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
