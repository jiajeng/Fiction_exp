% add a txt file to subject folder contains basic subject info
allbehavefile = 'E:\Fiction_experiment\Data\behave\50subjects_behavior score.xlsx';
allbehave = table2cell(readtable(allbehavefile,"Range","1:2","ReadVariableNames",false));
allbehavefile = readtable(allbehavefile,"Range","2:52","ReadVariableNames",true);
VarName = strcat(allbehave(2,:),repmat({'_'},1,size(allbehave,2)),allbehave(1,:));
p = 'E:\Fiction_experiment\Data';
sub = allbehavefile.No;
for i = 1:length(sub)
    outfile = fullfile(p,sub{i},'info.txt');
    tmp = append(string(VarName),string(repmat({' : '},1,size(allbehavefile,2))));
    tmp = append(tmp,string(cellfun(@num2str,table2cell(allbehavefile(i,:)),'UniformOutput',false)))';
    writematrix(tmp,outfile);
end