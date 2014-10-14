%function out = directiondetector(D)

EyePosition = D.FrameDataExp.EyePosition;
SaccadeEvent = D.FrameDataExp.SaccadeEvent; %might change this

[trialno,binno,dno] = size(EyePosition);

SaccCount = 0;

for trial = 1:trialno
    for bin = 2:binno
        if SaccadeEvent(trial,bin) - SaccadeEvent(trial,bin-1) == 1
            SaccCount = SaccCount + 1;
        end
    end
end

SaccStart = zeros(SaccCount,2);
SaccDetected = zeros(SaccCount,2);
SaccEnd = zeros(SaccCount,2);
SaccBear = zeros(SaccCount,2);
SaccCount = 0;

BearEstWindowItems = 5; EstWindow = BearEstWindowItems-1;

for trial = 1:trialno
    for bin = 16:binno-BearEstWindowItems
        if SaccadeEvent(trial,bin) - SaccadeEvent(trial,bin-1) == 1
            SaccCount = SaccCount + 1;
            
            SaccStart(SaccCount,1:2) = ...
                [mean(EyePosition(trial,bin-15:bin-10,1)), ...
                mean(EyePosition(trial,bin-15:bin-10,2))];
            
            SaccDetected(SaccCount,1:2) = ...% EyePosition(trial,bin,1:2);
                [mean(EyePosition(trial,bin:bin+EstWindow,1)), ...
                mean(EyePosition(trial,bin:bin+EstWindow,2))];
            
            while SaccadeEvent(trial,bin) == 1
                bin = bin + 1;
                
                if bin >= binno-6
                    SaccStart(SaccCount,1:2) = [nan nan];
                    SaccDetected(SaccCount,1:2) = [nan nan];
                    SaccCount = SaccCount - 1;
                    break
                end
                
                SaccEnd(SaccCount,1:2) = ...
                    [mean(EyePosition(trial,bin:bin+5,1)), ...
                    mean(EyePosition(trial,bin:bin+5,2))];
            end
            
            SaccBear(SaccCount,1) = ...
                findbearing(SaccStart(SaccCount,1),SaccStart(SaccCount,2),...
                SaccDetected(SaccCount,1),SaccDetected(SaccCount,2));
            
            SaccBear(SaccCount,2) = ...
                findbearing(SaccStart(SaccCount,1),SaccStart(SaccCount,2),...
                SaccEnd(SaccCount,1),SaccEnd(SaccCount,2));

        end
    end
end

SaccBearE = SaccBear;

for Saccade = 1:length(SaccBear)
    for column = 1:2
        if SaccBear(Saccade,column) >= 350
            SaccBearE(Saccade,:) = [0 0];
        end
        
        if SaccBear(Saccade,column) <= 10
            SaccBearE(Saccade,:) = [0 0];
        end 
    end
end

figure, scatter(SaccBearE(:,1),SaccBearE(:,2));
%[p,S] = polyfit(SaccBearE(:,1),SaccBearE(:,2),1);
[a b c d stats] = regress(SaccBearE(:,1),SaccBearE(:,2));

clear BearEstWindowItems column EstWindow EyePosition SaccCount SaccDetected SaccEnd...
    SaccStart Saccade SaccadeEndPosition SaccadeEvent SaccadeStartPosition ...
    a b bin binno c d dno trial trialno