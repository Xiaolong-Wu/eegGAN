tic
% close all;clear all;clc;
%%

% 1, Split1_strictConnectionCFC_GC
% 2, Split2_strictChannelCFC_GC
% 3, Split3_strictChannel

% 4, connection for Split3_strictChannel
% 5, schematic

% for 3 alpha [01 02 03 04 05 07 09 11 13 15]:
% D:\test_matlab\project_EEG\data_2020\0.4s(0.75)hamming(L)\morphology(0,13)Hz(0,125)ms(flat)\analysis(group_001)(group_005)(0.02)both.mat
% D:\test_matlab\project_EEG\data_2020\0.4s(0.75)hamming(L)\morphology(0,13)Hz(0,125)ms(flat)\analysis(group_001_002_003_004)(group_005_006_007_008)(0.02)both.mat
% for 3 theta [01 03 12]:
% D:\test_matlab\project_EEG\data_2020\0.4s(0.75)hamming(L)\morphology(0,30)Hz(0,77)ms(flat)\analysis(group_003)(group_007)(0.02)both.mat
% for 4 connection:
% D:\test_matlab\project_EEG\data_2020\0.4s(0.75)hamming(L)\CFC_GC(13,30)-(8,13)Hz(0.01)\analysis(group_*
% D:\test_manuscript\manuscript_2020\document\ch_conn\g4-3(sub-*

% rMask=input('which one splict?\n');

if rMask==1
    name_channel=[02 03 04 05 07 08 09 10 11 12 13 14 15];
    
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
    
    r_channelD_off=[];
    r_channelD_on1=[X01,X02,X03,X04,X05,X06,X07,X08,X09,X10,X11,X12,X13,X14,X15];
    r_channelD_on2=[Y01,Y02,Y03,Y04,Y05,Y06,Y07,Y08,Y09,Y10,Y11,Y12,Y13,Y14,Y15];
    
    connectionD_off=[
        ];
    connectionD_on=[
        r_channelD_on1;
        r_channelD_on2
        ]';
elseif rMask==2
    name_channel=[02 03 04 05 07 08 09 10 11 12 13 14 15];
    
    r_channelD_off=[];
    r_channelD_on1=[02 03 04 05 07 08 09 11 12 13 14 15];
    r_channelD_on2=[04 05 07 10 11];
    
    connectionD_off=[
        ];
    connectionD_on=[
        ];
elseif rMask==3
    name_channel=[01 02 03 04 05 07 09 11 12 13 15];
    
    r_channelD_off=[];
    r_channelD_on1=[01 03 12];
    r_channelD_on2=[01 02 03 04 05 07 09 11 13 15];
    
    connectionD_off=[
        ];
    connectionD_on=[
        ];
elseif rMask==4
    name_channel=[01 02 03 04 05 07 09 11 12 13 15];
    
    X01=[01,01,01,01,01,01,01,01,01,01];
    Y01=[01,02,03,04,05,07,09,11,13,15];
    X02=[];
    Y02=[];
    X03=[03,03,03,03,03];
    Y03=[02,04,07,11,15];
    X04=[];
    Y04=[];
    X05=[];
    Y05=[];
    X06=[];
    Y06=[];
    X07=[];
    Y07=[];
    X08=[];
    Y08=[];
    X09=[];
    Y09=[];
    X10=[];
    Y10=[];
    X11=[];
    Y11=[];
    X12=[12,12,12,12];
    Y12=[02,03,04,15];
    X13=[];
    Y13=[];
    X14=[];
    Y14=[];
    X15=[];
    Y15=[];
    
    r_channelD_off=[];
    r_channelD_on1=[X01,X02,X03,X04,X05,X06,X07,X08,X09,X10,X11,X12,X13,X14,X15];
    r_channelD_on2=[Y01,Y02,Y03,Y04,Y05,Y06,Y07,Y08,Y09,Y10,Y11,Y12,Y13,Y14,Y15];
    
    connectionD_off=[
        ];
    connectionD_on=[
        r_channelD_on1;
        r_channelD_on2
        ]';
elseif rMask==5
    name_channel=[];
    
    X01=[01];
    Y01=[12];
    X02=[];
    Y02=[];
    X03=[];
    Y03=[];
    X04=[];
    Y04=[];
    X05=[];
    Y05=[];
    X06=[];
    Y06=[];
    X07=[];
    Y07=[];
    X08=[];
    Y08=[];
    X09=[];
    Y09=[];
    X10=[];
    Y10=[];
    X11=[11];
    Y11=[02];
    X12=[];
    Y12=[];
    X13=[];
    Y13=[];
    X14=[];
    Y14=[];
    X15=[];
    Y15=[];
    
    r_channelD_off=[];
    r_channelD_on1=[X01,X02,X03,X04,X05,X06,X07,X08,X09,X10,X11,X12,X13,X14,X15];
    r_channelD_on2=[Y01,Y02,Y03,Y04,Y05,Y06,Y07,Y08,Y09,Y10,Y11,Y12,Y13,Y14,Y15];
    
    connectionD_off=[
        ];
    connectionD_on=[
        r_channelD_on1;
        r_channelD_on2
        ]';
end

connectionColorD_off=[1,1,1];

connectionColorD_on1=[1,0,0];
connectionColorD_on2=[1,1,0];
doubleORrainbow=1; % 0, double color; 1, rainbow color
nP=1000;

connectionWidthD_off=2;
connectionWidthD_on=3;

markerSizeBig=10;
markerSizeSmall=5;
makerSizeRainbow=4;

nChannel=15;
rRange=1.2;
cRange=2;

c_shadow=1;
c_NaNnumber=-0.05;
c_NaNcolor=[0,176,240]/255; % [0.5,0.5,0.5] [0,176,240]/255

name_high=0.15;

Rotation=15;
Tumbling=50;
%%

path_toolbox='D:\test_matlab\toolbox\eegGA\';
%%

connection={connectionD_off;connectionD_on};
connectionColor={connectionColorD_off;{connectionColorD_on1;connectionColorD_on2}};
connectionWidth={connectionWidthD_off;connectionWidthD_on};

addpath(genpath(path_toolbox));

coordinate=[];
coordinate_name=[];
coordinate_size=[];
load(['scalp(' num2str(nChannel) ').mat']);

figure
scalp_outline;

if c_shadow==1
    AmC=1.03;
    res=1000;
    
    x=AmC*coordinate(:,1)';
    y=AmC*coordinate(:,2)';
    
    [X,Y]=meshgrid(-rRange:2*rRange/res:rRange,-rRange:2*rRange/res:rRange);
    
    z=c_NaNnumber*ones(1,nChannel);
    Z=griddata(x,y,z,X,Y,'natural');
    
    [n1,n2]=size(Z);
    for r2=1:n1
        for r3=1:n2
            if X(r2,r3)^2+Y(r2,r3)^2>1^2
                Z(r2,r3)=NaN;
            end
        end
    end
    
    hold on;
    surf(X,Y,Z,'EdgeColor','none');
    
    colormap_temp=c_NaNcolor;
    colormap(colormap_temp);
end

for r=1:size(coordinate,1)
    
    if ismember(r,r_channelD_off) && ~ismember(r,r_channelD_on1) && ~ismember(r,r_channelD_on2)
        hold on;
        plot3(coordinate(r,1),coordinate(r,2),0,'o','MarkerSize',markerSizeBig,'MarkerFaceColor',connectionColorD_off,'MarkerEdgeColor','k','LineWidth',connectionWidthD_off);
    end
    if ismember(r,r_channelD_on1)
        hold on;
        plot3(coordinate(r,1),coordinate(r,2),0,'o','MarkerSize',markerSizeBig,'MarkerFaceColor',connectionColorD_on1,'MarkerEdgeColor','None','LineWidth',connectionWidthD_on);
    end
    if ismember(r,r_channelD_on2)
        hold on;
        plot3(coordinate(r,1),coordinate(r,2),0,'o','MarkerSize',markerSizeBig,'MarkerFaceColor','None','MarkerEdgeColor',connectionColorD_on2,'LineWidth',connectionWidthD_on);
    end
    if ~ismember(r,r_channelD_off) && ~ismember(r,r_channelD_on1) && ~ismember(r,r_channelD_on2)
        hold on;
        plot3(coordinate(r,1),coordinate(r,2),0,'o','MarkerSize',markerSizeSmall,'MarkerFaceColor','k','MarkerEdgeColor','k');
    end
    if ismember(r,name_channel)
        text(coordinate(r,1),coordinate(r,2),name_high,coordinate_name{r,1},'Color',[0 0 0],'Fontweight','bold','HorizontalAlignment','center');
    end
end

for r1=1:2
    
    connection_temp=connection{r1,1};
    nConnection=size(connection_temp,1);
    if nConnection<1
        continue;
    end
    
    for r2=1:nConnection
        
        x1=coordinate(connection_temp(r2,1),1);
        y1=coordinate(connection_temp(r2,1),2);
        
        x2=coordinate(connection_temp(r2,2),1);
        y2=coordinate(connection_temp(r2,2),2);
        
        r0=0;
        x=x1:(x2-x1)/(nP-1):x2;
        if length(x)<nP
            x=ones(1,nP)*(x1+x2)/2;
            r0=r0+1;
        end
        y=y1:(y2-y1)/(nP-1):y2;
        if length(y)<nP
            y=ones(1,nP)*(y1+y2)/2;
            r0=r0+1;
        end
        
        if r0~=2
            d=((x2-x1).^2+(y2-y1).^2).^(1/2);
            p=polyfit([0,d/2,d],[0,cRange/2,0],2);
            
            x_newCoordinate=((x-x1).^2+(y-y1).^2).^(1/2);
            y_newCoordinate=polyval(p,x_newCoordinate);
            
            z=y_newCoordinate;
            if r1==1
                hold on;
                plot3(x,y,z,'color',connectionColor{r1,1},'LineWidth',connectionWidth{r1,1});
            elseif r1==2
                
                if doubleORrainbow==0
                    nMid=floor(length(x)/2);
                    
                    hold on;
                    plot3(x(1:nMid),y(1:nMid),z(1:nMid),'color',connectionColor{r1,1}{1,1},'LineWidth',connectionWidth{r1,1});
                    hold on;
                    plot3(x(nMid+1:end),y(nMid+1:end),z(nMid+1:end),'color',connectionColor{r1,1}{2,1},'LineWidth',connectionWidth{r1,1});
                else
                    rAll=linspace(connectionColorD_on1(1),connectionColorD_on2(1),nP);
                    gAll=linspace(connectionColorD_on1(2),connectionColorD_on2(2),nP);
                    bAll=linspace(connectionColorD_on1(3),connectionColorD_on2(3),nP);
                    
                    for r3=1:nP
                        
                        hold on;
                        plot3(x(r3),y(r3),z(r3),'.','color',[rAll(r3),gAll(r3),bAll(r3)],'MarkerSize',makerSizeRainbow);
                    end
                end
            end
        end
    end
end

hold on;
plot3(0,0,-cRange,'k');
hold on;
plot3(0,0,cRange,'k');

axis([-rRange rRange -rRange rRange]);
axis equal;
axis off;

view(Rotation,Tumbling);

rmpath(genpath(path_toolbox));
toc