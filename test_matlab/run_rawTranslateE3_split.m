tic
close all;clear all;clc;
%%

path_dataOld='D:\test_matlab\project_EEG\data_2020\raw\dataSet_translateE2\';
path_dataNew='D:\test_matlab\project_EEG\data_2020\raw\dataSet_translateE3\';
path_toolbox='D:\test_matlab\toolbox\eegGA\';

subNo=[2 3 4 5 6 7 8 9 10 12];
runNo=[0 1 2 3 4];
fs=125;

Select=1;
energyDecreasingBand=[8,45];

T_dimension=1; % the total time dimension used for identification, unit: sec
centerRate=1/4; % the timestamp location rate of T_demension
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
            load(path_dataOld_temp);
            
            n_all=size(EEG,2);
            n_T_dimension=ceil(T_dimension*fs);
            n_T_dimensionL=ceil(T_dimension*fs*centerRate);
            n_T_dimensionR=n_T_dimension-n_T_dimensionL;
            n_event=size(Event);
            
            EEG_negative=[];
            EEG_positive=[];
            
            r0=0;
            r_negative=0;
            r_positive=0;
            
            firstOld=1;
            lastOld=0;
            for r3=1:n_event
                
                first=Event(r3,1)+1-n_T_dimensionL;
                last=first-1+n_T_dimension;
                
                if first<1
                    continue;
                elseif last>n_all
                    break;
                end
                
                if first-1-lastOld>=n_T_dimension
                    EEG_temp=EEG(:,lastOld+1:first-1);
                    
                    nChannel=size(EEG_temp,1);
                    ind_all=zeros(nChannel,1);
                    for r4=1:nChannel
                        
                        ind_all(r4,1)=selectRule(EEG_temp(r4,:),fs,energyDecreasingBand);
                    end
                    
                    if Select==0 || nChannel==sum(ind_all)
                        r0=r0+1;
                        r_negative=r_negative+1;
                        EEG_negative{r_negative,1}=EEG_temp;
                        EEG_negative{r_negative,2}=r0;
                        
                        lastOld=last;
                    end
                end
                
                EEG_temp=EEG(:,first:last);
                
                nChannel=size(EEG_temp,1);
                ind_all=zeros(nChannel,1);
                for r4=1:nChannel
                    
                    ind_all(r4,1)=selectRule(EEG_temp(r4,:),fs,energyDecreasingBand);
                end
                
                if Select==0 || nChannel==sum(ind_all)
                    r0=r0+1;
                    r_positive=r_positive+1;
                    EEG_positive{r_positive,1}=EEG_temp;
                    EEG_positive{r_positive,2}=r0;
                end
            end
            
            save(path_dataNew_temp,'EEG_negative','EEG_positive');
            disp([path_dataNew_temp ' have been done.']);
        end
    end
end
rmpath(genpath(path_toolbox));
toc