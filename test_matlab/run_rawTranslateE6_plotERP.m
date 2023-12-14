tic
close all;clear all;clc;
%%

path_data='D:\test_matlab\project_EEG\data_2020\raw\dataSet_translateE4\';
path_toolbox='D:\test_matlab\toolbox\eegGA\';

subNo=[2 3 4 5 6 7 8 9 10 12]; % [2 3 4 5 6 7 8 9 10 12]
runNo=[0]; % [0 1 2 3 4]
fs=125;

channelNo=[15 14 12 8 4 10 6 2 13 11 7 3 9 5 1]; % [15 14 12 8 4 10 6 2 13 11 7 3 9 5 1]
subplot_row=3;subplot_colum=5;
Band=[1,30];

% Arrange(1,1), baseline reset
% 0: do nothing
% 1: moving center to zero
% 2: removing mean
% Arrange(1,2), ERP plot
% 0: do nothing
% 1: negative reverse
% 2: color printing
Arrange=[2,2];
reverseThrTimes=2; % (1,inf), the bigger means that ERPs should be more obvious, used when Arrange(1,2)~=0

T_dimension=1; % the total time dimension used for identification, unit: sec
centerRate=1/4; % the timestamp location rate of T_demension
T_dimensionShowRate=0.4;
vRange=[-80,80];
vLim=[-35,35];

grayRate=[1,0.5];
Color=[
    grayRate(1,2)*ones(1,3);
    0,0,0;
    1,0,0;
    0,0,1
    ];
Legend={'outlier';'non-ERP';'Nx-ERP';'Px-ERP'}; % {'outlier';'non-ERP';'Nx-ERP';'Px-ERP'}
linePlot=[0;0;1;1];
lineWidth=[1;1;1;1];
orderColor=[1;3;4;2];

Statistics=5; % 1, mean; 2, median; 3, mean+&-; 4, median+&-; 5, all

lineWidth_1=2;
lineWidth_2=2;
lineWidth_3=20;

proLim=[0,0.6];
markerSize=6;

figureSize_1={1;[0,0,900,550]};
figureSize_2={1;[0,550,150,150]};
figureSize_3={1;[900,0,350,150]};
%%

addpath(genpath(path_toolbox));

if figureSize_1{1,1}==1
    figure
    set(gcf,'position',figureSize_1{2,1});
end

nChannel=sum(channelNo~=0);
load(['scalp(' num2str(nChannel) ').mat']);

nSubNo=length(subNo);
nRunNo=length(runNo);

n_T_dimensionL=ceil(T_dimension*fs*centerRate);
n_T_dimension_show=ceil(T_dimension*fs*T_dimensionShowRate);
n_T_dimensionL_show=ceil(T_dimension*fs*centerRate*T_dimensionShowRate);

first=n_T_dimensionL-n_T_dimensionL_show+1;
last=first-1+n_T_dimension_show;

t=1000*(1:n_T_dimension_show)/fs;
t_stamp=t(n_T_dimensionL_show);

nColor=size(Color,1);
nOrderColor=size(orderColor,1);
nERP=zeros(nChannel,nOrderColor);

r0=0;
for r1=1:length(channelNo)
    
    if channelNo(1,r1)~=0
        
        r0=r0+1;
        sAll=cell(nColor,2);
        
        for r2=1:nColor
            
            sAll{r2,1}=Color(r2,:);
        end
        
        if figureSize_1{1,1}==1
            subplot(subplot_row,subplot_colum,r0);
            plot([t_stamp t_stamp],vLim,'color',[0,1,0],'LineWidth',lineWidth_3);
            hold on;
            plot([t(1) t(end)],[0 0],'color',[0,0,0],'LineWidth',lineWidth_2);
            hold on;
        end
        
        for r2=1:nSubNo
            
            cSubNo=num2code(subNo(r2),2);
            for r3=1:nRunNo
                
                path_dataGroupRestMI=[path_data 'positive\'];
                path_dataGroupRestMI_temp=[path_dataGroupRestMI 'sub-' cSubNo '-' num2str(runNo(1,r3)) '.mat'];
                load(path_dataGroupRestMI_temp);
                
                if sum(size(EEG))==0
                    continue;
                end
                
                nBlock=size(EEG,1);
                for r4=1:nBlock
                    
                    ERP_temp=EEG{r4,1}(channelNo(1,r1),:);
                    
                    [~,s_PS]=wave_PS(ERP_temp,fs,Band,[0 0],'flat');
                    s_filter=s_PS{1,1}(1,:);
                    
                    s_filter_show=s_filter(first:last);
                    
                    if Arrange(1,1)==2
                        ArrangeVal=mean(s_filter_show(1:n_T_dimensionL_show));
                        s_filter_show_arrange=s_filter_show-ArrangeVal;
                    elseif Arrange(1,1)==1
                        ArrangeVal=s_filter_show(n_T_dimensionL_show);
                        s_filter_show_arrange=s_filter_show-ArrangeVal;
                    else
                        s_filter_show_arrange=s_filter_show;
                    end
                    
                    if Arrange(1,2)==2
                        s_ref=s_filter_show_arrange(n_T_dimensionL_show+1:n_T_dimension_show);
                        s_refMax=max(s_ref);
                        s_refMin=min(s_ref);
                        if s_refMin>0 || (s_refMax>0 && abs(s_refMax/s_refMin)>reverseThrTimes)
                            colorTemp=sAll{4,1};
                        elseif s_refMax<0 || (s_refMin<0 && abs(s_refMin/s_refMax)>reverseThrTimes)
                            colorTemp=sAll{3,1};
                        else
                            colorTemp=sAll{2,1};
                        end
                    elseif Arrange(1,2)==1
                        colorTemp=sAll{2,1};
                        s_ref=s_filter_show_arrange(n_T_dimensionL_show+1:n_T_dimension_show);
                        s_refMax=max(s_ref);
                        s_refMin=min(s_ref);
                        if s_refMax<0 || (s_refMin<0 && abs(s_refMin/s_refMax)>reverseThrTimes)
                            s_filter_show_arrange=-s_filter_show_arrange;
                        end
                    else
                        colorTemp=sAll{2,1};
                    end
                    
                    if grayRate(1,1)==1
                        s_ref=s_filter_show_arrange(n_T_dimensionL_show+1:n_T_dimension_show);
                        if min(s_ref)<vRange(1,1) || max(s_ref)>vRange(1,2)
                            colorTemp=sAll{1,1};
                        end
                    end
                    
                    for r5=1:nColor
                        if isequal(colorTemp,sAll{r5,1})
                            sAll{r5,2}=[sAll{r5,2};s_filter_show_arrange];
                        end
                    end
                end
            end
        end
        
        for r2=orderColor'
            
            sPlot=sAll{r2,2};
            if sum(size(sPlot))~=0
                n_sPlot=size(sPlot,1);
                if figureSize_1{1,1}==1 && linePlot(r2,1)==1
                    if Statistics==1
                        plot(t,mean(sPlot,1),'color',sAll{r2,1},'LineWidth',lineWidth(r2,1));
                        hold on;
                    elseif Statistics==2
                        plot(t,median(sPlot,1),'color',sAll{r2,1},'LineWidth',lineWidth(r2,1));
                        hold on;
                    elseif Statistics==3
                        plot(t,mean(sPlot,1),'color',sAll{r2,1},'LineWidth',lineWidth(r2,1));
                        hold on;
                        plot(t,mean(sPlot,1)-std(sPlot,0,1),'--','color',sAll{r2,1},'LineWidth',ceil(lineWidth(r2,1)/2));
                        hold on;
                        plot(t,mean(sPlot,1)+std(sPlot,0,1),'--','color',sAll{r2,1},'LineWidth',ceil(lineWidth(r2,1)/2));
                        hold on;
                    elseif Statistics==4
                        plot(t,median(sPlot,1),'color',sAll{r2,1},'LineWidth',lineWidth(r2,1));
                        hold on;
                        plot(t,min(sPlot,[],1),'--','color',sAll{r2,1},'LineWidth',ceil(lineWidth(r2,1)/2));
                        hold on;
                        plot(t,max(sPlot,[],1),'--','color',sAll{r2,1},'LineWidth',ceil(lineWidth(r2,1)/2));
                        hold on;
                    else
                        plot(repmat(t,n_sPlot,1)',sPlot','color',sAll{r2,1},'LineWidth',lineWidth(r2,1));
                        hold on;
                    end
                end
                nERP(r0,r2)=n_sPlot;
            end
        end
        
        if figureSize_1{1,1}==1
            xlim([t(1) t(end)]);
            ylim(vLim);
            if r0>(subplot_row-1)*subplot_colum
                xlabel('time/ msec','Fontweight','bold');
            else
                set(gca,'xTick',[]);
            end
            if mod(r0,subplot_colum)==1
                ylabel('EEG/ ¦ÌV','Fontweight','bold');
            else
                set(gca,'yTick',[]);
            end
            title(['ch. ' coordinate_name{r0,1}],'Fontweight','bold');
        end
    end
end

if figureSize_2{1,1}==1
    orderLegend=cell(nOrderColor,1);
    for r=1:nOrderColor
        
        orderLegend{r,1}=Legend{orderColor(r,1),1};
    end
    
    figure
    set(gcf,'position',figureSize_2{2,1});
    for r=orderColor'
        
        plot(0,0,'color',sAll{r,1},'LineWidth',lineWidth_1);
        hold on;
    end
    axis off;
    legend(orderLegend,'Fontweight','bold');
end
rmpath(genpath(path_toolbox));

tbl=table(nERP,'RowNames',coordinate_name);

if figureSize_3{1,1}==1
    nERPrate=zeros(nChannel,nOrderColor);
    nERP_temp=sum(nERP,2);
    for r=1:nChannel
        
        nERPrate(r,:)=nERP(r,:)/nERP_temp(r,1);
    end
    
    nERPrate_mean=mean(nERPrate,1);
    nERPrate_std=std(nERPrate,0,1);
    
    figure
    set(gcf,'position',figureSize_3{2,1});
    bar(nERPrate_mean,0.6,'LineWidth',lineWidth_2,'FaceColor','none');
    for r=1:nOrderColor
        
        hold on;
        plot([r r],[nERPrate_mean(1,r)-nERPrate_std(1,r) nERPrate_mean(1,r)+nERPrate_std(1,r)],'color',sAll{r,1},'LineWidth',lineWidth_2);
        hold on;
        plot(r,nERPrate_mean(1,r)-nERPrate_std(1,r),'o','MarkerSize',markerSize,'MarkerFaceColor',sAll{r,1},'MarkerEdgeColor',sAll{r,1});
        hold on;
        plot(r,nERPrate_mean(1,r)+nERPrate_std(1,r),'o','MarkerSize',markerSize,'MarkerFaceColor',sAll{r,1},'MarkerEdgeColor',sAll{r,1});
    end
    set(gca,'XTick',1:nOrderColor,'XTickLabel',Legend,'Fontweight','bold');
    xlim([0,nOrderColor+1]);
    ylim(proLim);
end
toc