function stat_2ndlevel(file,pn,varargin)
    % model +-arousal = deltaPower + thetaPower + alphaPower + betaPower

    varname = varargin(1:2:end);
    varvar = varargin(2:2:end);
    for i = 1:length(varname)
        v = varname{i};
        switch v
            case 'effectN'
                effectN = varvar{i};
                if class(effectN)~="cell"
                    error("effectN data type is cell detect input is %s",class(effectN));
                end
            case 'modlsep'
                modelspec = varvar{i};
                if class(modelspec)~="string" && class(modelspec)~="char"
                    error("modelspec data type is char or string, detect input is %s",class(modelspec));
                end
        end
    end

    % load PARfile
    if contains(file,'*')
        if ~contains(file,"*.mat")
            PARfile = dir(fullfile(file,'*.mat'));
        else
            PARfile = dir(fullfile(file));
        end
        PARfile = fullfile({PARfile.folder}',{PARfile.name}');
    end

    GLMfile = PARfile(contains(PARfile,'GLM.mat'));
    PARfile = PARfile(contains(PARfile,'Par.mat'));

    a = split(GLMfile{1},filesep);
    b = split(GLMfile{2},filesep);
    idx = string(a) == string(b);
    if exist("effectN",'var')
        f = strjoin(effectN,'_');
        outputfile = fullfile(a{1:find(idx==0)-1},'Result','2ndLevel',pn,f);
    end
    figoutputpath = fullfile(outputfile,'chk_figure');
    if ~exist(figoutputpath,'dir'), mkdir(figoutputpath); end
    if length(GLMfile) ~= length(PARfile)
        assignin("base",'GLMfile',GLMfile);
        assignin("base",'PARfile',PARfile);
        error('GLM.mat file is not same as Par.mat file')
    end
    % initial variables
    GLM = load(GLMfile{1});
    GLM = GLM.GLM;
    CHANNELNAME = fieldnames(GLM.fstLevel);
    outGLM = struct();

    for CHi = 1:length(CHANNELNAME)
        DataStruct = GLM.fstLevel.(CHANNELNAME{CHi});
        AllBeta = zeros(length(GLMfile),size(DataStruct.lm.Coefficients,1));
        Allt = AllBeta;
        X_name = DataStruct.X_name;
        Par = load(PARfile{1});
        Alleffect = zeros(length(GLMfile),length(Par.effect_name));
        for SUBi = 1:length(GLMfile)
            % get every subject Beta value
            GLM = load(GLMfile{SUBi});
            GLM = GLM.GLM;
            DataStruct = GLM.fstLevel.(CHANNELNAME{CHi});
            Par = load(PARfile{SUBi});
            AllBeta(SUBi,:) = DataStruct.lm.Coefficients.Estimate;
            Allt(SUBi,:) = DataStruct.lm.Coefficients.tStat;
            BetaName = DataStruct.lm.CoefficientNames;
            BetaName(string(BetaName)=="contrast") = [];
            BetaName = strrep(BetaName,':','_');
            % get subject covariate
            Alleffect(SUBi,:) = Par.effect;
            EffctName = Par.effect_name;
        end
        AllBeta(:,contains(BetaName,'Intercept')) = [];
        BetaName(contains(BetaName,'Intercept')) = [];
    
        for Betai = 1:length(BetaName)
            beName = BetaName{Betai};
            Y = AllBeta(:,Betai);
            idx = cell2mat(cellfun(@(x) string(EffctName)==x,effectN,'UniformOutput',false)');
            idx = any(idx,1);
            effctName = effectN;
            X = Alleffect(:,idx);
            outGLM.sndLevel.(CHANNELNAME{CHi}).(beName).X = X;
            outGLM.sndLevel.(CHANNELNAME{CHi}).(beName).Y = Y;
            outGLM.sndLevel.(CHANNELNAME{CHi}).(beName).X_name = effctName;
            outGLM.sndLevel.(CHANNELNAME{CHi}).(beName).Y_name = beName;
    
            % normalize X and Y
            % Y = (Y-mean(Y,1))./std(Y,[],1);
            % X = (X-mean(X,1))./std(X,[],1);
            % outGLM.sndLevel.(CHANNELNAME{CHi}).(beName).normX = X;
            % outGLM.sndLevel.(CHANNELNAME{CHi}).(beName).normY = Y;
           

            % GLM
            if ~exist("modelspec",'var')
                eff = effctName(~contains(effctName,'Age')&~contains(effctName,'Sex'));
                modelspec = strjoin(eff,' + ');
                if ~isempty(modelspec)
                    modelspec = [beName,' ~ Age + Sex + Age*(',modelspec,')'];
                    LM = fitlm(X,Y,modelspec,'VarNames',[effctName,{beName}]);
                else
                    LM = fitlm(X,Y,'VarNames',[effctName,{beName}]);
                end
                clear("modelspec")
            else
                Modelspec = [beName,' ~ ',modelspec];
                LM = fitlm(X,Y,Modelspec,'VarNames',[effctName,{beName}]);
            end
            
            outGLM.sndLevel.(CHANNELNAME{CHi}).(beName).LM = LM;
            idx = LM.Coefficients.pValue<0.05;
            outGLM.sndLevel.(CHANNELNAME{CHi}).(beName).effect = LM.CoefficientNames(idx);

            plot(X,Y,'o');
            legend(Par.X_name)
            title([CHANNELNAME{CHi},'\_',beName]);
            xlabel('X');
            ylabel('Y');
            saveas(gcf,fullfile(figoutputpath,[CHANNELNAME{CHi},'_',beName,'.jpeg']));
            close(gcf);

            plot(LM);
            saveas(gcf,fullfile(figoutputpath,[CHANNELNAME{CHi},'_',beName,'_LM.jpeg']));
            close(gcf);
        end
    end
    GLM = outGLM;
    if ~exist(outputfile,'dir'), mkdir(outputfile); end 

    save(fullfile(outputfile,'GLM.mat'),"GLM");
end