function eDat2evt(sub,eDatfile,evtpath)
    % get EEG trial
    file = 'E:\Fiction_experiment\Data\behave\Fiction Raweeg trial list.xlsx';
    sheet = sheetnames(file);
    sheet = sheet(~contains(sheet,'Summary'));

    SHEET = sheetnames(eDatfile);
    evtTab = table();
    evtTabVarN = {sub,'Character','Story','story. no.','Condition','Arousal','Q2.ACC','Q3.ACC','Eye.OnsetDelay'};
    story_no = dictionary('P',60,'N',50);
    PN = dictionary('P','4','N','3');
    avertPN = dictionary('4','3','3','4');
    
    trial_id = 1;
    for nst = 1:length(SHEET)
        eDatTab = readtable(eDatfile,"Sheet",SHEET(nst));
        if size(eDatTab,2) < 60, continue; end
        eDatTab(isnan(eDatTab.Subject),:) = [];
        eDatTab = readtable(eDatfile,"Sheet",SHEET(nst),"Range",['2:',num2str(2+size(eDatTab,1))],'ReadVariableNames',true);
        if eDatTab.Properties.VariableNames{1} ~= "ExperimentName"
            eDatTab = readtable(eDatfile,"Sheet",SHEET(nst),"Range",['1:',num2str(1+size(eDatTab,1))],'ReadVariableNames',true);
        end
       
        % name 
        name = eDatTab.Name;
        if any(contains(name,"莉賽爾"))
            intro = eDatTab.intro;
            [~,nid] = unique(eDatTab.Block);
            nid = [nid, nid+3];
            intro(cellfun(@isempty,intro)) = [];
            intro = cellfun(@(x) x(1:3),intro,'UniformOutput',false);
            yli = cellfun(@(x) x=="9歲小",intro);
            name(nid(yli,1):nid(yli,2)) = {'少女莉賽爾'};
        end
        if contains(eDatTab.Properties.VariableNames,'Con_re')
            conTabname = 'Con_re';
        else
            conTabname = 'Condition';
        end

        % % condition2
        % con2 = convertStringsToChars(string(num2str(eDatTab.(conTabname))));
        % tmp = eDatTab.('Que3_ACC');
        % con2(~tmp) = cellfun(@(x) [x,'9'],con2(~tmp),'UniformOutput',false);
        % eyeGaze = num2str(mod(eDatTab.(conTabname),10));
        % Q2Res = eDatTab.('Que2_RESP');
        % Q2Res = cellfun(@(x) x(x=='P'|x=='N'),Q2Res);
        % 
        % % condition3
        % con3 = PN(Q2Res);
        % con3 = convertStringsToChars(string(strcat([char(con3),char(eyeGaze)])));
        % id = find(contains(con3,'3')&contains(con3,'4'));
        % for i = 1:length(id)
        %     con3{id(i)}(end) = '1';
        % end
        % con3(~tmp) = cellfun(@(x) [x,'9'],con3(~tmp),'UniformOutput',false);


        % all tab
        tmp = [
            array2table([trial_id:trial_id+size(eDatTab,1)-1]',"VariableNames",{'sub'}), ...
            array2table(name,"VariableNames",{'Character'}), ... % character
            eDatTab(:,'PN'),... % story 
            array2table(story_no(string(eDatTab.PN)),"VariableNames",{'story'}),... % story no
            eDatTab(:,conTabname),... % conditoin 
            eDatTab(:,'Que1_Slider1_Value'), ... % Arousal
            eDatTab(:,'Que2_ACC'),...
            eDatTab(:,'Que3_ACC'), ...
            eDatTab(:,'Eye_OnsetDelay')
            ];
        tmp.Properties.VariableNames = evtTabVarN;
        evtTab = cat(1,evtTab,tmp);
        trial_id = trial_id+size(eDatTab);
    end
    % read eeg trial table
    tab = readtable(file,"Sheet",sheet(cellfun(@(x) contains(eDatfile,x),sheet)));
    if ~isempty(tab)
        try
            dupVar = intersect(evtTab.Properties.VariableNames,tab.Properties.VariableNames);
            evtTab(:,dupVar) = [];
            evtTab = cat(2,evtTab,tab);
        catch ME
            if ME.message == "All tables being horizontally concatenated must have the same number of rows."
                if size(tab,1)>size(evtTab,1)
                    nevttab = cell(size(tab,1),size(evtTab,2));
                    idx = find(tab.Condition2~=99);
                    for rs = 1:length(idx)
                        nevttab(idx(rs),:) = table2cell(evtTab(rs,:));
                    end
                else
                    fprintf('%s is not raw is more than EEG trial xlsx',eDatfile);
                    return;
                end
                nevttab = cell2table(nevttab,"VariableNames",evtTab.Properties.VariableNames);
                evtTab = cat(2,nevttab,tab);
            end
        end
    end
    if ~exist(evtpath,"dir"), mkdir(evtpath); end
    writetable(evtTab,fullfile(evtpath,[sub,'_triallist.xlsx']));
end