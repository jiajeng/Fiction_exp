rawPath = 'E:\Fiction_experiment\Data';
nevtPath = 'E:\Fiction_experiment\Data\behave\newTriallist';

sub = {dir(rawPath).name};
sub = sub(~contains(sub,'.') & ~contains(sub,'behave'));

allfile = {dir(nevtPath).name};
DUR = [];
for nsub = 1:length(sub)
    dur = readtable(fullfile(nevtPath,allfile{contains(allfile,sub{nsub})}));
    tmp = dur.dur;
    if size(dur,1)<72
        tmp = zeros(72,1);
        id = table2array(dur(:,1));
        tmp(id) = dur.dur;
    end
    DUR = cat(2,DUR,tmp);
end
CHARA = {'克郎','小王子','小王子的朋友','晴美','浩介','漢斯','牧羊少年','瑪格麗特','簡愛','約瑟夫','艾迪','莉賽爾','少女莉賽爾','雄治','靜子','魯迪','麥克斯','水晶店老闆'};
CONDI = {'31', '33', '41', '44'};
trial_id = dictionary();
for i = 1:length(CHARA)
    for j = 1:length(CONDI)
        trial_id([CHARA{i},'_',CONDI{j}]) = (i-1)*(length(CONDI))+j;
    end
end
DUR = DUR';
DUR(DUR==0) = nan;
DUR = cat(1,DUR,mean(DUR,1,'omitmissing'));
DUR = cat(1,DUR,max(DUR,[],1,'omitmissing'));
DUR = cat(1,DUR,min(DUR,[],1,'omitmissing'));
DUR = cat(1,DUR,std(DUR,[],1,'omitmissing'));


DUR = array2table(DUR,'RowNames',[sub,{'mean','max','min','std'}]','VariableNames',keys(trial_id));

writetable(DUR,'E:\Fiction_experiment\Data\behave\ReadTime.xlsx','WriteRowNames',true)
