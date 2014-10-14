function plotcorrectionsaccades(D,SaccadeEvent,SaccDirection,SaccSize)

[trialno, binno, dno] = size(D.FrameDataExp.EyePosition);

DO = D.FrameDataExp.DisplayOffset;

DisplayOffsetDirection = zeros(trialno,binno);

SaccadeDirectionTime = SaccadeEvent;
SaccadeSizeTime = SaccadeEvent;

for trial = 1:trialno
    
    SaccadeID = 0; OffsetDirection = 0;
    
    if sum(DO(trial,:,1))...
            + sum(DO(trial,:,2)) == 0
        continue
    end
    
    for bin = 2:binno
        
        if SaccadeEvent(trial,bin) > SaccadeEvent(trial,bin-1)
            SaccadeID = SaccadeID + 1;
            
            while SaccadeEvent(trial,bin) == 1
                
                SaccadeDirectionTime(trial,bin) =...
                    SaccDirection(trial,SaccadeID);
                
                SaccadeSizeTime(trial,bin) = SaccSize(trial,SaccadeID);
                
                bin = bin + 1;
                
            end
            
        end
        
        if DO(trial,bin,1) ~= DO(trial,bin-1,1)
            OffsetDirection = findbearing(DO(trial,bin-1,1),DO(trial,bin-1,2),...
                DO(trial,bin,1),DO(trial,bin,2));
        end
            
        DisplayOffsetDirection(trial,bin) = OffsetDirection;
        
    end
    
    figure, [ax,H1,H2] = plotyy(1:binno,SaccadeDirectionTime(trial,:),1:binno,SaccadeSizeTime(trial,:)); hold all;
        set(ax(1),'Ylim',[0 360]); set(ax(1),'YTick',[0:45:360])
        set(ax(2),'Ylim',[0 5]); set(ax(2),'YTick',[0:0.5:5])
        plot(DisplayOffsetDirection(trial,:),'color','red'); hold off;
    
end
    
