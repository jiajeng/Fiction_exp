function RmOutlier(evtfile,epochfilepath,subpath)
    % get reading duration in evtfile(./behave/newTraillist/{subject}_event.xlsx)
    % outlier information is store in ./subject/info.txt file 
    % copy epoch trial that not outlier in epoch file path
    % save to epochfilepath
    % (copy file from ./process/trials_21to22 to ./process/rmOtlir_trials_21to22)
    % require input :
    %   evtfile, "string", evtfile path can directly read 
    %   epochfilepath, "string", dir that contains eeg trial data can have
    %   "*" or "**" to find certain pattern dir

    % read evt file get dur column
    evttable = readtable(evtfile);

    % find every subject outlier
    dur = evttable.dur;
    TRIALid = table2array(evttable(:,1));
    uB = mean(dur)+2*std(dur);
    lB = mean(dur)-2*std(dur);
    rtTriali = dur<uB & dur>lB;

    % save outlier idx
    evttable.outlier = double(~rtTriali);
    tmp = NaN(size(rtTriali));
    tmp(1) = uB;
    tmp(2) = lB;
    evttable.outlier_bound = tmp;
    writetable(evttable,evtfile);

    % save how many trials that removed 
    infofile = fullfile(subpath,'info.txt');
    info = readcell(infofile,'Delimiter',' ');
    idx = contains(info(:,1),'remove_trial(+-2*std)');
    if any(idx)
        tmp = cellfun(@num2str,num2cell(TRIALid(~rtTriali))','UniformOutput',false);
        tmp = [tmp;repmat({','},size(tmp))];
        tmp{end,end} = ['-->',num2str(sum(~rtTriali)),'/',num2str(length(TRIALid))];
        tmp = strjoin(tmp,'');
        info{idx,3} = tmp;
    else
        info{end+1,1} = 'remove_trial(+-2*std)';
        info{end,2} = ':';
        tmp = cellfun(@num2str,num2cell(TRIALid(~rtTriali))','UniformOutput',false);
        tmp = [tmp;repmat({','},size(tmp))];
        tmp{end,end} = ['-->',num2str(sum(~rtTriali)),'/',num2str(length(TRIALid))];
        tmp = strjoin(tmp,'');
        info{end,3} = tmp;
    end
    writecell(info,fullfile(subpath,'info.txt'),'Delimiter',' ');


    % move retain epoch file to a new folder
    epfilepath = dir(epochfilepath);
    epfilepath(~[epfilepath.isdir]) = [];
    if length(epfilepath) > 1, error(['detect more than one in this filter(path)',epochfilepath]);end
    outputpath = fullfile(epfilepath.folder,['rmOtlir_',epfilepath.name]);
    epfilepath = fullfile(epfilepath.folder,epfilepath.name);

    % get file id 
    Trialfile = {dir(epfilepath).name};
    Trialfile = Trialfile(3:end);
    fileID = squeeze(split(Trialfile,'_'));
    fileID = fileID(:,1);
    fileID = cellfun(@(x) str2num(x(2:end)), fileID);
    reorderID = arrayfun(@(x) find(TRIALid==x),unique(fileID,'stable'));
    rortTriali = rtTriali(reorderID);
    rortTriali = reshape(repmat(rortTriali,1,2)',size(fileID));

    % delete fileID that been removed
    % Trialfile = fileID(rortTriali);
    Trialfile = Trialfile(rortTriali);
    if ~exist(outputpath,'dir'), mkdir(outputpath);end
    for i = 1:length(Trialfile)
        copyfile(fullfile(epfilepath,Trialfile{i}),fullfile(outputpath,Trialfile{i}));
    end
end