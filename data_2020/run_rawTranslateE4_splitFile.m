tic
close all;clear all;clc;
%%

path_dataOld='D:\test_matlab\project_EEG\data_2020\raw\dataSet_translateE3\';
path_dataNew='D:\test_matlab\project_EEG\data_2020\raw\dataSet_translateE4\';
path_toolbox='D:\test_matlab\toolbox\eegGA\';

subNo=[2 3 4 5 6 7 8 9 10 12];
runNo=[0 1 2 3 4];
groups={'negative';'positive'};
%%

if ~exist(path_dataNew,'dir')
    mkdir(path_dataNew);
end
%%

addpath(genpath(path_toolbox));

nSubNo=length(subNo);
nRunNo=length(runNo);
nGroups=length(groups);
for r1=1:nSubNo
    
    cSubNo=num2code(subNo(r1),2);
    for r2=1:nRunNo
        
        path_dataOld_temp=[path_dataOld 'sub-' cSubNo '-' num2str(runNo(1,r2)) '.mat'];
        for r3=1:nGroups
            
            path_dataNewGroupRestMI=[path_dataNew groups{r3,1} '\'];
            if ~exist(path_dataNewGroupRestMI,'dir')
                mkdir(path_dataNewGroupRestMI);
            end
            
            path_dataNewGroupRestMI_temp=[path_dataNewGroupRestMI 'sub-' cSubNo '-' num2str(runNo(1,r2)) '.mat'];
            if exist(path_dataNewGroupRestMI_temp,'file')
                disp([path_dataNewGroupRestMI_temp ' exist, skip.']);
            else
                load(path_dataOld_temp);
                
                if r3==1
                    EEG=EEG_negative;
                elseif r3==2
                    EEG=EEG_positive;
                end
                
                save(path_dataNewGroupRestMI_temp,'EEG');
                disp([path_dataNewGroupRestMI_temp ' have been done.']);
            end
        end
    end
end
rmpath(genpath(path_toolbox));
toc