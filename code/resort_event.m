function resort_event(evtpath,evtfile,outeventpath)
    evTTab = readtable(fullfile(evtpath,evtfile));
    % delete id == 99
    id = evTTab.Condition2;
    if any(id==99)
        evTTab(id==99,:) = [];
    end
    % delete eye
    evTchar = string(evTTab.Character);
    evTcond = evTTab.Condition2;
    evTcond = arrayfun(@num2str,evTcond,'UniformOutput',false);
    evTcond = string(cellfun(@(x) x(1:2),evTcond,'UniformOutput',false));
    % set trial id ordinary template
    CHARA = {'克郎','小王子','小王子的朋友','晴美','浩介','漢斯','牧羊少年','瑪格麗特','簡愛','約瑟夫','艾迪','莉賽爾','少女莉賽爾','雄治','靜子','魯迪','麥克斯','水晶店老闆'};
    CONDI = {'31', '33', '41', '44'};
    trial_id = dictionary();
    for i = 1:length(CHARA)
        for j = 1:length(CONDI)
            trial_id([CHARA{i},'_',CONDI{j}]) = (i-1)*(length(CONDI))+j;
        end
    end

    % resort table
    nevTTab = table();
    KEY = keys(trial_id);
    for i = 1:length(KEY)
        k = KEY{i};
        tmp = split(k,'_');
        ch = tmp{1};
        cond = tmp{2};
        nevTTab = cat(1,nevTTab,evTTab(evTchar==ch & evTcond==cond,:));
        nevTTab{i,1} = trial_id([ch,'_',cond]);
    end
    nevTTab(cellfun(@isempty,nevTTab.Character),:) = [];
    % save table
    if ~exist(outeventpath,'dir'),mkdir(outeventpath); end
    writetable(nevTTab,fullfile(outeventpath,evtfile));
end