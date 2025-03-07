function stat_plotPNresult_nointercption(Resfile,CMPfile,outputpath)
    for ncon = 1:length(Resfile)
        try
            if contains(Resfile{ncon},'GLM.mat')
                if contains(Resfile{ncon},'*')
                    Resdir = dir(Resfile{ncon});
                    if length(Resdir) > 1, error('L>1'); end
                    Res = load(fullfile(Resdir.folder,Resdir.name));
                else
                    Res = load(Resfile{ncon});
                end
            else
                Resdir = dir(fullfile(Resfile{ncon},'GLM.mat'));
                if length(Resdir) > 1, error('L>1'); end
                Res = load(fullfile(Resdir.folder,Resdir.name));
            end
        catch ME
            if ME.message == "L>1"
                for i = 1:length(Resdir)
                    disp(fullfile(Resdir(i).folder,Resdir(i).name));
                end
                error('detect more than one GLM.mat for 2nd level')
            end
            rethrow(ME);
        end
        Resdir = dir(Resfile{ncon});
        % outputpath = fullfile(Resdir.folder,'Res_figure');
        if ~exist(outputpath,'dir'), mkdir(outputpath); end
        channel_name={'','Fp1','','Fp2','',...
                      'F7','F3','Fz','F4','F8',...
                      'FC5','FC1','','FC2','FC6',...
                      'T7','C3','Cz','C4','T8',...
                      'CP5','CP1','','CP2','CP6',...
                      'P7','P3','Pz','P4','P8',...
                      '','O1','Oz','O2',''};
    
        Res = Res.GLM.sndLevel;
        CHANNELNAME = fieldnames(Res);
        FBname = fieldnames(Res.(CHANNELNAME{1}));
        FrqName = FBname;
        xdif = 0.2;
        if ncon==1
            xdif = -xdif;
        end
        threshold = 0.05;
        subplot_row = 7;
        subplot_col = 5;
        for CHi = 1:length(CHANNELNAME)
            if any(contains(channel_name,CHANNELNAME{CHi}))
                for FREQi = 1:length(FBname)
                    CONDITION = Res.(CHANNELNAME{CHi}).(FBname{FREQi}).LM.CoefficientNames;
                    CONDITION = strrep(CONDITION,'_','\_');
                    % CONDITION{contains(CONDITION,'Intercept')} = 'Intercept';
                    CONDITION(contains(CONDITION,'Intercept')) = [];
                    
                    for CONDI = 1:length(CONDITION)
                        figure(FREQi);
                        set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    
                        subplot(subplot_row,subplot_col,find(string(channel_name)==CHANNELNAME{CHi}))
                        beta = Res.(CHANNELNAME{CHi}).(FBname{FREQi}).LM.Coefficients.Estimate(CONDI+1);
    
                        %% beta
                        % plot beta value 
                        plot([CONDI+xdif,CONDI+xdif],[0,beta],'LineWidth',10);hold on;
                        % xlimit is 0~length(CONDITION)+1
                        xlim([0.5,length(CONDITION)+0.5]);
                        % title = {SET_name}_{FB_name}
                        title([CHANNELNAME{CHi},'\_',FBname{FREQi}])
                        % x label name is CONDITION (wind score self) in x = 1 2 3
                        xticks(1:length(CONDITION))
                        xticklabels(CONDITION);
                        if CONDI ~= length(CONDITION)
                            xline(CONDI+0.5,'--');
                        end
                    end % condition
                    ylimt = ylim;
                    ylim([ylimt(1)-diff(ylimt)/5,ylimt(2)+diff(ylimt)])
                    % plot line y=0
                    yline(0,'--') 
                    ylabel('Beta value','FontWeight','bold');
    
                    %% significant star
                    ylimt = ylim;
                    for CONDi = 1:length(CONDITION)
                        p = Res.(CHANNELNAME{CHi}).(FBname{FREQi}).LM.Coefficients.pValue(CONDi);
                        if p < threshold
                            sigX = CONDi+xdif;
                            sigY = ylimt(2)-(diff(ylimt)/5);
                            plot(sigX,sigY,'*','Color','r','MarkerSize',4);
                            strp = sprintf('%.3f',p);
                            text(sigX(end)+0.1,sigY(end),5,['p:',strp],'FontSize',7);
                        end
                    end
                end % Frequency
            end
        end% Channel
    end

    %% compare line if significant
    % read file 
    try
        if contains(CMPfile,'GLM.mat')
            if contains(CMPfile,'*')
                Resdir = dir(CMPfile);
                if length(Resdir) > 1, error('L>1'); end
                Res = load(fullfile(Resdir.folder,Resdir.name));
            else
                Res = load(CMPfile);
            end
        else
            Resdir = dir(fullfile(CMPfile,'GLM.mat'));
            if length(Resdir) > 1, error('L>1'); end
            Res = load(fullfile(Resdir.folder,Resdir.name));
        end
    catch ME
        if ME.message == "L>1"
            for i = 1:length(Resdir)
                disp(fullfile(Resdir(i).folder,Resdir(i).name));
            end
            error('detect more than one GLM.mat for 2nd level')
        end
        rethrow(ME);
    end
    % loop for get pvalue 
    Res = Res.GLM.sndLevel;
    FBname = fieldnames(Res.(CHANNELNAME{CHi}));
    FBname = FBname(contains(FBname,'contrast'));
    for CHi = 1:length(CHANNELNAME)
        if any(contains(channel_name,CHANNELNAME{CHi}))
            for FREQi = 1:length(FBname)
                cmpPriditor = Res.(CHANNELNAME{CHi}).(FBname{FREQi}).LM.CoefficientNames;
                cmpPriditor = strrep(cmpPriditor,'_','\_');
                cmpPriditor{contains(cmpPriditor,'Intercept')} = 'Intercept';
                
                %% significant line
                
                for CONDi = 1:length(CONDITION)
                    figure(FREQi);
                    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);  
                    p = Res.(CHANNELNAME{CHi}).(FBname{FREQi}).LM.Coefficients.pValue(string(cmpPriditor) == string(CONDITION{CONDi}));
                    if p < threshold
                         subplot(subplot_row,subplot_col,find(string(channel_name)==CHANNELNAME{CHi}))
                        sigX = [CONDi-abs(xdif),CONDi+abs(xdif)];
                        ylimt = ylim;
                        sigY = [ylimt(2)-(diff(ylimt)/10),ylimt(2)-(diff(ylimt)/10)];
                        plot(sigX,sigY,'Color','r','LineWidth',1);
                        strp = sprintf('%.3f',p);
                        text(sigX(end)+0.1,sigY(end),5,['p:',strp],'FontSize',7);
                    end
                end
            end
        end
    end


    for FREQi = 1:length(FrqName)
        figure(FREQi);
        annotation('textbox',[0.5 0.55 0.1 0.1],'String',FrqName{FREQi},'LineStyle','none','FontSize',20);
        saveas(gcf,fullfile(outputpath,[FrqName{FREQi},'.jpeg']))
    end
    close all;
end
