function stat_1stlevel(PARfile)
    % model +-arousal = deltaPower + thetaPower + alphaPower + betaPower

    % load PARfile
    if contains(PARfile,'*')
        if ~contains(PARfile,"Par.mat")
            PARfile = dir(fullfile(PARfile,'Par.mat'));
        else
            PARfile = dir(fullfile(PARfile));
        end
        PARfile = {PARfile.folder};
    end
    GLM = struct();
    Par = load(fullfile(PARfile{:},'Par.mat'));
    
    Y = Par.Y;
    X = Par.X;
    CHANNELNAME = fieldnames(X);
    figoutputpath = fullfile(PARfile{:},'chk_figure');
    if ~exist(figoutputpath,'dir'), mkdir(figoutputpath); end
    for CHi = 1:length(CHANNELNAME)
        x = X.(CHANNELNAME{CHi});
        % Y = abs(Y);
        X_name = Par.X_name;
        contrast = x(:,string(X_name) == "contrast");
        % normalize X, Y
        Y = (Y-mean(Y,1))./std(Y,[],1);
        x = (x-mean(x,1))./std(x,[],1);
        x(:,string(X_name) == "contrast") = contrast;

        
        Y_name = Par.Y_name{:};
        eff = X_name(~contains(X_name,'contrast'));
        if any(contains(X_name,'contrast'))
            modelspec = strjoin(eff,' + ');
            modelspec = [Y_name,' ~ contrast*(',modelspec,')'];
        else
            modelspec = [];
        end

        plot(x,Y,'o');
        legend(Par.X_name)
        title(CHANNELNAME{CHi});
        xlabel('X');
        ylabel('Y');
        saveas(gcf,fullfile(figoutputpath,[CHANNELNAME{CHi},'.jpeg']));
        close(gcf);

        if size(Par.X_name,1)>1
            Vn = [Par.X_name',Par.Y_name];
        else
            Vn = [Par.X_name,Par.Y_name];
        end
        if ~isempty(modelspec)
            lm = fitlm(x,Y,modelspec,'VarNames',Vn);
        else
            lm = fitlm(x,Y,'VarNames',Vn);
        end

        plot(lm);
        saveas(gcf,fullfile(figoutputpath,[CHANNELNAME{CHi},'_LM.jpeg']));
        close(gcf);

        GLM.fstLevel.(CHANNELNAME{CHi}).lm = lm;
        GLM.fstLevel.(CHANNELNAME{CHi}).X_name = Par.X_name;
        GLM.fstLevel.(CHANNELNAME{CHi}).Y_name = Par.Y_name;
    end
    save(fullfile(PARfile{:},'GLM.mat'),"GLM");

end