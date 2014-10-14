[trialno,binno,dno] = size(EyePositionS);

SaccCount = zeros(trialno,1);
SaccStart = nan(trialno,25,2);
SaccEnd = nan(trialno,25,2);
SaccDirection = nan(trialno,25);

tic
for trial = 1:trialno
    
    clc;
    fprintf('Savitzky-Golay filtering: Complete\n');
    fprintf('Saccade Detection: Complete\n');
    fprintf('Direction Detection: In Progress\n');
    fprintf('    Trial %d of %d\n\n',trial,trialno);
    
    for bin = 2:binno
        
        if SaccadeEventNH(trial,bin) == 1 &&...
                SaccadeEventNH(trial,bin-1) == 0
            
            SaccCount(trial) = SaccCount(trial) + 1;
            SaccStart(trial,SaccCount(trial),:) = EyePositionS(trial,bin,1:2);
            
            binsacc = bin;
            
            while SaccadeEventNH(trial,binsacc) == 1
                binsacc = binsacc + 1;
                SaccEnd(trial,SaccCount(trial),:) = EyePositionS(trial,binsacc,1:2);
            end
            
            SaccDirection(trial,SaccCount(trial)) = ...
                findbearing(SaccStart(trial,SaccCount(trial),1),SaccStart(trial,SaccCount(trial),2),...
                SaccEnd(trial,SaccCount(trial),1),SaccEnd(trial,SaccCount(trial),2));
            
        end
    end
end