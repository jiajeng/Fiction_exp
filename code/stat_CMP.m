function stat_CMP(Pos_fold,Nes_fold,outputpath)
     try
        if contains(Pos_fold,'GLM.mat')
            if contains(Pos_fold,'*')
                Resdir = dir(Pos_fold);
                if length(Resdir) > 1, error('L>1'); end
                Res_p = load(fullfile(Pos_fold.folder,Pos_fold.name));
            else
                Res_p = load(Pos_fold);
            end
        else
            Resdir = dir(fullfile(Pos_fold,'GLM.mat'));
            if length(Resdir) > 1, error('L>1'); end
            Res_p = load(fullfile(Resdir.folder,Resdir.name));
        end
        Res_p = Res_p.GLM.sndLevel;
        if contains(Nes_fold,'GLM.mat')
            if contains(Nes_fold,'*')
                Resdir = dir(Nes_fold);
                if length(Resdir) > 1, error('L>1'); end
                Res_n = load(fullfile(Nes_fold.folder,Nes_fold.name));
            else
                Res_n = load(Nes_fold);
            end
        else
            Resdir = dir(fullfile(Nes_fold,'GLM.mat'));
            if length(Resdir) > 1, error('L>1'); end
            Res_n = load(fullfile(Resdir.folder,Resdir.name));
        end
        Res_n = Res_n.GLM.sndLevel;
    catch ME
        if ME.message == "L>1"
            for i = 1:length(Resdir)
                disp(fullfile(Resdir(i).folder,Resdir(i).name));
            end
            error('detect more than one GLM.mat for 2nd level')
        end
        rethrow(ME);
    end

    CHANNELNAME = fieldnames(Res_n);
    FBName = fieldnames(Res_p.(CHANNELNAME{1}));
    CoefficientNames = Res_p.(CHANNELNAME{1}).(FBName{1}).LM.CoefficientNames;
    modl = [Res_p.C3.alpha.LM.Formula.ResponseName,' ~ ',Res_p.C3.alpha.LM.Formula.LinearPredictor];
    Varname = [Res_p.C3.alpha.X_name,{Res_p.C3.alpha.Y_name}];
    permTime = 1000;     
    GLM.res_p = Res_p;
    GLM.res_n = Res_n;
    for chidx = 1:length(CHANNELNAME)
        for fbidx = 1:length(FBName)
            res_p = Res_p.(CHANNELNAME{chidx}).(FBName{fbidx}).LM.Coefficients.Estimate;
            res_n = Res_n.(CHANNELNAME{chidx}).(FBName{fbidx}).LM.Coefficients.Estimate;
            real_dif = res_p-res_n;
            permDif = zeros(length(res_p),permTime);

            X_p = Res_p.(CHANNELNAME{chidx}).(FBName{fbidx}).X;
            X_n = Res_n.(CHANNELNAME{chidx}).(FBName{fbidx}).X;
            Y_p = Res_p.(CHANNELNAME{chidx}).(FBName{fbidx}).Y;
            Y_n = Res_n.(CHANNELNAME{chidx}).(FBName{fbidx}).Y;
            simY_p = cell(1,permTime);
            simY_n = cell(1,permTime);
            for i = 1:permTime
                simY_n{i} = Y_n(randperm(length(Y_n)));
                simY_p{i} = Y_p(randperm(length(Y_p)));
            end
            
            parfor i = 1:permTime
                LM_p = fitlm(X_p,simY_p{i},modl,'VarNames',Varname);
                LM_n = fitlm(X_n,simY_n{i},modl,'VarNames',Varname);
                permDif(:,i) = LM_p.Coefficients.Estimate-LM_n.Coefficients.Estimate;
            end
            
            CMPp = min(sum(real_dif>permDif,2)./permTime,1-sum(real_dif>permDif,2)./permTime);
            GLM.cmp.(CHANNELNAME{chidx}).(FBName{fbidx}).X_n = X_n;
            GLM.cmp.(CHANNELNAME{chidx}).(FBName{fbidx}).X_p = X_p;
            GLM.cmp.(CHANNELNAME{chidx}).(FBName{fbidx}).Y_p = simY_p;
            GLM.cmp.(CHANNELNAME{chidx}).(FBName{fbidx}).Y_n = simY_n;
            GLM.cmp.(CHANNELNAME{chidx}).(FBName{fbidx}).permTimes = permTime;
            GLM.cmp.(CHANNELNAME{chidx}).(FBName{fbidx}).modlsepc = modl;
            % GLM.cmp.(CHANNELNAME{chidx}).(FBName{fbidx}).LM_p_n = Res_p.(CHANNELNAME{chidx}).(FBName{fbidx}).LM;
            GLM.cmp.(CHANNELNAME{chidx}).(FBName{fbidx}).LM.Coefficients.Estimate = real_dif;
            GLM.cmp.(CHANNELNAME{chidx}).(FBName{fbidx}).LM.CoefficientNames = CoefficientNames;
            % GLM.cmp.(CHANNELNAME{chidx}).(FBName{fbidx}).LM.Coefficients.tValue = nan(size(real_dif));
            % GLM.cmp.(CHANNELNAME{chidx}).(FBName{fbidx}).LM.Coefficients.SE = nan(size(real_dif));
            GLM.cmp.(CHANNELNAME{chidx}).(FBName{fbidx}).LM.Coefficients.pValue = CMPp;
        end
    end
    if ~exist(outputpath,'dir'), mkdir(outputpath); end
    save(fullfile(outputpath,'GLM.mat'),"GLM")
end