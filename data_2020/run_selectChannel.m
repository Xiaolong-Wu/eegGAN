tic
close all;clear all;clc;
%%

path_eegGA='D:\test_matlab\toolbox\eegGA\';
%%

resultSub={
    'resultAllSplit1_strictConnectionCFC_GC';
    'resultAllSplit2_strictChannelCFC_GC';
    'resultAllSplit3_strictChannel'
    };
subNo=[2 5 7 8]; % [2 5 7 8]
%%

addpath(genpath([path_eegGA 'function\']));
%%

nResultSub=size(resultSub,1);
nSubNo=length(subNo);
for r1=1:nResultSub % nResultSub
    for r2=1:nSubNo
        
        name_result=[resultSub{r1,1} '\resultSub-' num2code(subNo(r2),2)];
        
        featureSet=[];
        load([name_result '\result.mat']);
        if isfield(featureSet,'svm_result')
            continue;
        end
        
        if length(featureSet.featureSelection)~=10
            keyboard;
        end
        
        disp([name_result '\result.mat']);
        disp(' ');
        
        if r1==1
            featureSet.featureSelection(1).r_channel=[];
            featureSet.featureSelection(2).r_channel=[];
            featureSet.featureSelection(3).r_channel=[];
            featureSet.featureSelection(4).r_channel=[];
            
            featureSet.featureSelection(5).r_channel=[];
            featureSet.featureSelection(6).r_channel=[];
            featureSet.featureSelection(7).r_channel=[];
            
            featureSet.featureSelection(8).r_channel=[];
            featureSet.featureSelection(9).r_channel=[];
            
            X01=[];
            Y01=[];
            X02=[02,02,02];
            Y02=[04,07,10];
            X03=[03];
            Y03=[04];
            X04=[04,04];
            Y04=[04,07];
            X05=[05];
            Y05=[04];
            X06=[];
            Y06=[];
            X07=[07];
            Y07=[04];
            X08=[08,08,08];
            Y08=[04,05,11];
            X09=[09];
            Y09=[04];
            X10=[];
            Y10=[];
            X11=[11,11,11];
            Y11=[04,07,10];
            X12=[12];
            Y12=[04];
            X13=[13];
            Y13=[11];
            X14=[14];
            Y14=[04];
            X15=[15];
            Y15=[04];
            featureSet.featureSelection(10).r_channel=[Y01,Y02,Y03,Y04,Y05,Y06,Y07,Y08,Y09,Y10,Y11,Y12,Y13,Y14,Y15;X01,X02,X03,X04,X05,X06,X07,X08,X09,X10,X11,X12,X13,X14,X15];
            
            featureSet.featureSelection(9)=[];
            featureSet.featureSelection(8)=[];
            featureSet.featureSelection(7)=[];
            featureSet.featureSelection(6)=[];
            featureSet.featureSelection(5)=[];
            featureSet.featureSelection(4)=[];
            featureSet.featureSelection(3)=[];
            featureSet.featureSelection(2)=[];
            featureSet.featureSelection(1)=[];
        elseif r1==2
            featureSet.featureSelection(1).r_channel=[];
            featureSet.featureSelection(2).r_channel=[];
            featureSet.featureSelection(3).r_channel=[2:5,7:9,11:15];
            featureSet.featureSelection(4).r_channel=[4,5,7,10,11];
            
            featureSet.featureSelection(5).r_channel=[];
            featureSet.featureSelection(6).r_channel=[];
            featureSet.featureSelection(7).r_channel=[];
            
            featureSet.featureSelection(8).r_channel=[];
            featureSet.featureSelection(9).r_channel=[];
            featureSet.featureSelection(10).r_channel=[];
            
            featureSet.featureSelection(10)=[];
            featureSet.featureSelection(9)=[];
            featureSet.featureSelection(8)=[];
            featureSet.featureSelection(7)=[];
            featureSet.featureSelection(6)=[];
            featureSet.featureSelection(5)=[];
            featureSet.featureSelection(2)=[];
            featureSet.featureSelection(1)=[];
        elseif r1==3
            featureSet.featureSelection(1).r_channel=[];
            featureSet.featureSelection(2).r_channel=[];
            featureSet.featureSelection(3).r_channel=[1,3,12];
            featureSet.featureSelection(4).r_channel=[1:5,7,9,11,13,15];
            
            featureSet.featureSelection(5).r_channel=[];
            featureSet.featureSelection(6).r_channel=[];
            featureSet.featureSelection(7).r_channel=[];
            
            featureSet.featureSelection(8).r_channel=[];
            featureSet.featureSelection(9).r_channel=[];
            featureSet.featureSelection(10).r_channel=[];
            
            featureSet.featureSelection(10)=[];
            featureSet.featureSelection(9)=[];
            featureSet.featureSelection(8)=[];
            featureSet.featureSelection(7)=[];
            featureSet.featureSelection(6)=[];
            featureSet.featureSelection(5)=[];
            featureSet.featureSelection(2)=[];
            featureSet.featureSelection(1)=[];
        end
        
        save([name_result '\result.mat'],'featureSet')
    end
end
%%

rmpath(genpath([path_eegGA 'function\']));
toc