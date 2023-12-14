tic
close all;clear all;clc;
%%

path_dataOld='D:\test_matlab\project_EEG\data_2020\raw\dataSet_translateE4\';
path_dataNew='D:\test_matlab\project_EEG\data_2020\raw\dataSet_translateE5\';
path_toolbox='D:\test_matlab\toolbox\eegGA\';

subNo=[2 3 4 5 6 7 8 12];
runNo=[1 2 3 4];
groups={'negative';'positive'};
%%

if ~exist(path_dataNew,'dir')
    mkdir(path_dataNew);
end
%%

addpath(genpath(path_toolbox));

nSubNo=length(subNo);
nGroups=length(groups);
nRunNo=length(runNo);
for r1=1:nSubNo
    
    cSubNo=num2code(subNo(r1),2);
    for r2=1:nGroups
        
        path_dataNewGroupRestMI=[path_dataNew groups{r2,1} '\'];
        if ~exist(path_dataNewGroupRestMI,'dir')
            mkdir(path_dataNewGroupRestMI);
        end
        
        path_dataNewGroupRestMI_temp=[path_dataNewGroupRestMI 'sub-' cSubNo '-all.mat'];
        if exist(path_dataNewGroupRestMI_temp,'file')
            disp([path_dataNewGroupRestMI_temp ' exist, skip.']);
        else
            EEG_all={};
            
            for r3=1:nRunNo
                
                path_dataOld_temp=[path_dataOld groups{r2,1} '\' 'sub-' cSubNo '-' num2str(runNo(1,r3)) '.mat'];
                
                EEG=[];
                load(path_dataOld_temp);
                
                if size(EEG,1)>0
                    EEG_all=[EEG_all;EEG];
                end
            end
            
            EEG=EEG_all;
            save(path_dataNewGroupRestMI_temp,'EEG');
            disp([path_dataNewGroupRestMI_temp ' have been done.']);
        end
    end
end
rmpath(genpath(path_toolbox));
toc