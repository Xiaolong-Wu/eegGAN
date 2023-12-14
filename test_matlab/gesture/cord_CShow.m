function cord_CShow(pPreM,fps,cordMat,nNode,oNode,cordShift,plotPreSec,connNode,colorNode,lineWidth,markerSize,xRange,yRange,plotPause,colorMap)

nT=size(cordMat{1,1},1);

if isempty(cordShift)
    cordPlot=cordMat;
else
    oCord=cordMat{oNode,1};
    cordMatSmoothZero=cell(nNode,1);
    for r2=1:nNode
        
        cordMatSmoothZero{r2,1}=cordMat{r2,1}-oCord;
    end
    if cordShift==0
        cordPlot=cordMatSmoothZero;
    elseif cordShift>0
        pPreFrame=cordShift*pPreM/fps;
        cordMatSmoothLine=cordMatSmoothZero;
        for r2=1:nNode
            
            cordMatSmoothLine{r2,1}(:,1)=cordMatSmoothLine{r2,1}(:,1)+((0:nT-1)*pPreFrame)';
        end
        cordPlot=cordMatSmoothLine;
    else
        pPreFrame=cordShift*pPreM/fps;
        cordMatSmoothLine=cordMat;
        for r2=1:nNode
            
            cordMatSmoothLine{r2,1}(:,1)=cordMatSmoothLine{r2,1}(:,1)-((0:nT-1)*pPreFrame)';
        end
        cordPlot=cordMatSmoothLine;
    end
end

figure

eval(['colormap_temp=colormap(' colorMap '(nT));']);
plotInterval=ceil(fps/plotPreSec);
for r2=1:plotInterval:nT
    for r3=1:size(connNode,1)
        
        rNode=connNode{r3,1};
        xConn=zeros(1,2);
        yConn=zeros(1,2);
        for r4=1:2
            
            xConn(1,r4)=cordPlot{rNode(1,r4),1}(r2,1);
            yConn(1,r4)=cordPlot{rNode(1,r4),1}(r2,2);
        end
        
        plot(xConn/pPreM,yConn/pPreM,'LineWidth',lineWidth,'color',colormap_temp(r2,:));
        hold on;
    end
    
    for r3=1:nNode
        
        x=cordPlot{r3,1}(r2,1);
        y=cordPlot{r3,1}(r2,2);
        plot(x/pPreM,y/pPreM,'Marker','o','MarkerSize',markerSize,'MarkerFaceColor',colorNode(r3,:),'MarkerEdgeColor',colormap_temp(r2,:));
        hold on;
    end
    
    axis equal;
    if ~isempty(xRange)
        xlim(xRange);
    end
    if ~isempty(yRange)
        ylim(yRange);
    end
    pause(plotPause);
end
end