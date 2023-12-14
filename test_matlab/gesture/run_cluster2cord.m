tic
close all;clear all;clc;
%%

path_dataCluster=[pwd '\cluster_C.mat'];
path_dataCord=[pwd '\cord_C.mat'];
%%

if exist(path_dataCord,'file')
    disp([path_dataCord ' exist, skip!']);
else
    
    cluster_C=[];
    load(path_dataCluster);
    nT=size(cluster_C,1);
    nNode=size(cluster_C,2)/2;
    
    cordMat=cell(nNode,1);
    for r1=1:nT
        for r2=1:nNode
            
            cordMat{r2,1}(r1,:)=cluster_C(r1,(2*r2-1):(2*r2));
        end
    end
    
    save(path_dataCord,'cordMat');
    disp([path_dataCord ' have been saved.']);
end
%%

fps=30;
colorMap='jet';
oNode=1;

% []: no shift;
% 0: shift oNode to zero;
% positive: shift oNode to zero and a line with cordShift m/ sec;
% negtive: shift oNode to a line with cordShift m/ sec;
cordShift=7;

plotPreSec=30;

connNode={
    [18,02];
    [01,03];
    [03,04];
    [04,05];
    [03,06];
    [06,07];
    [07,08];
    [08,09];
    [06,10];
    [10,11];
    [11,12];
    [12,13];
    [10,14];
    [14,15];
    [15,16];
    [16,17];
    [14,18];
    [18,19];
    [19,20];
    [20,21]
    };
colorNode=ones(21,3)*0.5;
lineWidth=2;
markerSize=5;

xRange=[-0.15,0.55];
yRange=[-0.05,0.25];

plotPause=0.05;
%%

cordMat=[];
load(path_dataCord);
nNode=size(cordMat,1);

cord_CShow(1,fps,cordMat,nNode,oNode,cordShift,plotPreSec,connNode,colorNode,lineWidth,markerSize,xRange,yRange,plotPause,colorMap);
toc