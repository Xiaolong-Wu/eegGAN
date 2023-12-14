tic
close all;clear all;clc;
%%

path_dataOld='D:\test_matlab\project_EEG\data_2020\raw\dataSet_translateE1\';
path_dataNew='D:\test_matlab\project_EEG\data_2020\raw\dataSet_translateE2\';
path_toolbox='D:\test_matlab\toolbox\eegGA\';

subNo=[2 3 4 5 6 7 8 9 10 12];
runNo=[0 1 2 3 4];

eventType_MI=[7];
%%

if ~exist(path_dataNew,'dir')
    mkdir(path_dataNew);
end
%%

addpath(genpath(path_toolbox));

nSubNo=length(subNo);
nRunNo=length(runNo);
for r1=1:nSubNo
    
    cSubNo=num2code(subNo(r1),2);
    for r2=1:nRunNo
        
        path_dataOld_temp=[path_dataOld 'sub-' cSubNo '-' num2str(runNo(1,r2)) '.mat'];
        path_dataNew_temp=[path_dataNew 'sub-' cSubNo '-' num2str(runNo(1,r2)) '.mat'];
        
        if exist(path_dataNew_temp,'file')
            disp([path_dataNew_temp ' exist, skip.']);
        else
            EEG=[];
            load(path_dataOld_temp);
            
            temp_EEG=EEG.data;
            temp_event=floor([[EEG.event.latency]',[EEG.event.type]']);
            
            r0=0;
            for r3=1:size(temp_event,1)
                
                r0=r0+1;
                if r0>size(temp_event,1)
                    break;
                end
                
                if ~ismember(temp_event(r0,2),eventType_MI)
                    temp_event(r0,:)=[];
                    r0=r0-1;
                    
                    continue;
                end
                
                if r0>1 && temp_event(r0-1,1)==temp_event(r0,1)
                    
                    temp_type=max(temp_event(r0-1,2),temp_event(r0,2));
                    temp_event(r0-1,2)=temp_type;
                    
                    temp_event(r0,:)=[];
                    r0=r0-1;
                end
            end
            
            EEG=double(temp_EEG);
            Event=temp_event;
            
            save(path_dataNew_temp,'EEG','Event');
            disp([path_dataNew_temp ' have been done.']);
        end
    end
end
rmpath(genpath(path_toolbox));
toc