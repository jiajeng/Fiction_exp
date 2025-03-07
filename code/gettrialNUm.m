p = 'E:\Fiction_experiment\Data';
sub = {dir(p).name};
sub = sub(~contains(sub,'.'));

trialnum = cell(length(sub),1);
for nsub = 1:length(trialnum)
    file = dir(fullfile(p,sub{nsub},'**','Raw','*.set'));
    N = 0;
    for nfile = 1:length(file)
        EEG = pop_loadset(file(nfile).name,file(nfile).folder);
        tn = {EEG.event.type};
        tn = sum(contains(tn,'21'));
        N = N + tn;
    end     
    trialnum{nsub} = N;
end