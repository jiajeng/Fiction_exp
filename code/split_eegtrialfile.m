% Concatenate palin organize eeg event file(Fiction Raweeg trial list.xlsx)
% to event file(p01_triallist.xlsx)

file = 'E:\Fiction_experiment\Data\behave\Fiction Raweeg trial list.xlsx';
Tofilepath = 'E:\Fiction_experiment\Data\behave\evtList';
TOFILE = {dir(Tofilepath).name};
TOFILE = TOFILE(3:end);
pth = 'E:\Fiction_experiment\Data';
sheet = sheetnames(file);
sheet = sheet(~contains(sheet,'Summary'));
% sheet = subname
for i = 1:length(sheet)
    try
        tab = readtable(file,"Sheet",sheet(i));
        if isempty(tab), continue; end
        % writetable(tab,fullfile(pth,char(sheet(i)),'EEGtrialList.csv'));
        Tofile = TOFILE{contains(TOFILE,sheet(i))};
        evttab = readtable(fullfile(Tofilepath,Tofile));
        dupVar = intersect(evttab.Properties.VariableNames,tab.Properties.VariableNames);
        evttab(:,dupVar) = [];
        evttab = cat(2,evttab,tab);
        writetable(evttab,fullfile(Tofilepath,Tofile));
    catch ME
        if ME.message == "All tables being horizontally concatenated must have the same number of rows."
            if size(tab,1)>size(evttab,1)
                nevttab = cell(size(tab,1),size(evttab,2));
                idx = find(tab.Condition2~=99);
                for rs = 1:length(idx)
                    nevttab(idx(rs),:) = table2cell(evttab(rs,:));
                end
            end
            nevttab = cell2table(nevttab,"VariableNames",evttab.Properties.VariableNames);
            evttab = cat(2,nevttab,tab);
            writetable(evttab,fullfile(Tofilepath,Tofile));
        end
        continue;
    end
end
