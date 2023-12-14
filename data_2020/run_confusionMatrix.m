tic
close all;clear all;clc;
%%

% TP FN tpr=TP/(TP+FN)
% FP TN fpr=TP/(FP+TN)

nModel=6;
nGroupSet=3;

figureSize1={1;[300,300,300,150]};
figureSize2={1;[300,300,600,250]};
%%

confusionMatrix_LSTM=[];
negativeSample=[];
positiveSample=[];
load('confusionMatrix.mat');

figure
if figureSize1{1,1}==1
    set(gcf,'position',figureSize1{2,1});
end
caxis([0,1]);
colormapTemp=colormap(bone);
axis off;
colorbar('FontWeight','bold');

nColormapTemp=size(colormapTemp,1);
for r1=1:nModel
    
    figure
    if figureSize2{1,1}==1
        set(gcf,'position',figureSize2{2,1});
    end
    for r2=1:nGroupSet
        
        temp_tpr=confusionMatrix_LSTM(r1).TPR{r2,1};
        temp_fpr=confusionMatrix_LSTM(r1).FPR{r2,1};
        
        temp_fnr=1-temp_tpr;
        temp_tnr=1-temp_fpr;
        
        temp_tp=floor(positiveSample.*temp_tpr);
        temp_fp=floor(negativeSample.*temp_fpr);
        
        temp_fn=positiveSample-temp_tp;
        temp_tn=negativeSample-temp_fp;
        
        accRate=[mean(temp_tpr),mean(temp_fnr);mean(temp_fpr),mean(temp_tnr)];
        accSample=[sum(temp_tp),sum(temp_fn);sum(temp_fp),sum(temp_tn)];
        
        subplot(1,nGroupSet,r2)
        imagesc(accRate);
        caxis([0,1]);
        colormap(bone);
        set(gca,'XAxisLocation','top');
        axis equal;
        axis off;
        
        for r3=1:2
            for r4=1:2
                
                temp_accRate=accRate(r3,r4);
                temp_accSample=accSample(r3,r4);
                if temp_accRate>0.5
                    rColormapTemp=1;
                else
                    rColormapTemp=nColormapTemp;
                end
                text(r4,r3,num2str(temp_accSample),'Color',colormapTemp(rColormapTemp,:),'HorizontalAlignment','center','FontWeight','bold');
            end
        end
        
        title(['feature construction ' num2str(r2)],'FontWeight','bold');
    end
    suptitle(confusionMatrix_LSTM(r1).model);
end

toc