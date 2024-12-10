function [errorfile,errorTab,outTab] = vhdr2set(varargin)
    % input : 'vhdrpath', "string", Get all .vhdr file in this path
    %         'vhdrfile', "struct", fields is folder and name
    %        !! vhdrfile has priority, means if enter path and file then
    %           this code will run the file that define in file.
    % output : save .set file in vhdrfilepath/../eegSet/Raw
    %         

    opathf = false;
    % set varin
    varname = varargin(1:2:end);
    varvar = varargin(2:2:end);
    for i = 1:length(varname)
        v = varname{i};
        switch v
            case 'vhdrpath'
                vhdrpath = varvar{i};
                if class(vhdrpath) ~= "string" && class(vhdrpath) ~= "char"
                    error(['vhdrpath data type is "string" or "char", input is ',class(vhdrpath)]); 
                end
                vDf = false;
            case 'vhdrfile'
                vD = varvar{i};
                if class(vD) ~= "struct"
                    error(['outpath data type is "struct", input is ',class(vD)]); 
                end
                vDf = true;
            otherwise
                error(['do not know input ',v]);
        end
    end

    %% --------------------main---------------------------
    % get file dir
    outTab = {'folder','name'};
    errorTab = {'folder','name','errorMsg'};
    if ~vDf
        vD = dir(fullfile(vhdrpath,'**','*.vhdr'));
    end
    % for every file
    for nfile = 1:length(vD)
        % define output path
        outpath = fullfile(vD(nfile).folder,'..','eegSet','Raw');
        try
            % get EEG
            EEG = pop_loadbv(vD(nfile).folder,vD(nfile).name);
            % create outpath
            if ~exist(outpath,'dir'), mkdir(outpath); end
            % save EEG .set file
            pop_saveset(EEG,'filename',vD(nfile).name,'filepath',outpath);
            % store save info
            outTab = cat(1,outTab,{outpath,vD(nfile).name});
        catch ME
            % store error info
            errorTab = cat(1,errorTab,{vD(nfile).folder,vD(nfile).name,ME.message});
        end
    end
    errorfile = cell2struct(errorTab(2:end,1:2),errorTab(1,1:2),2);
end