%to go with allcalc_2

StableAccelerationStdev = 510;
StableAccelerationMean = 670;
StableSpeedStdev = 2.54;
StableSpeedMean = 3.38;

[trialno,binno,dno] = size(EyePosition);
SaccadeEventC = zeros(trialno,binno);
SaccadeCount = 0;

P = 19.8;
SpeedOffThresh = 15;

SpeedThresh = StableSpeedMean + StableSpeedStdev * P;
AccelThresh = 0; %StableAccelerationMean + StableAccelerationStdev * P;
SaccadeCount = 0;

for trial = 1:trialno
    for bin = 2:binno
        if (abs(EyeSpeed(trial,bin,3))-SpeedThresh)...
                *(abs(EyeSpeed(trial,bin-1,3))-SpeedThresh) <= 0;
            if abs(EyeAccel(trial,bin,3)) >= AccelThresh
                %if GazeStable(trial,bin) ~= 1
                    SaccadeEventC(trial,bin) = 1;
                %end
            end
        end
        
        if SaccadeEventC(trial,bin-1) == 1
            if abs(EyeSpeed(trial,bin,3)) > SpeedOffThresh
                SaccadeEventC(trial,bin) = 1;
            end
        end
        
    end
end

%         for trial = 1:trialno
%             for bin = 2:binno
%                 if SaccadeEventC(trial,bin) == 1
%                     if SaccadeEventC(trial,bin-1) == 0
%                         SaccadeCount(i) = SaccadeCount(i)+1;
%                     end
%                 end
%             end
%         end

for trial = 1:trialno
    SaccStart = nan;
    SaccEnd = nan;
    
    for bin = 2:binno
        if SaccadeEventC(trial, bin) == 1
            if SaccadeEventC(trial,bin-1) == 0
                SaccStart = TrialTime(trial,bin);
            end
        end
        if SaccadeEventC(trial,bin) == 0
            if SaccadeEventC(trial,bin-1) == 1
                if isnan(SaccStart) == 0
                    SaccEnd = TrialTime(trial,bin);
                    SaccadeCount = SaccadeCount + 1;
                    SaccLength(1,SaccadeCount) = SaccEnd - SaccStart;
                end
            end
        end
        
    end
end




%% Cleanup
clear AccelThresh P SpeedThresh StableAccelerationStdev ...
    StableSpeedMean StableSpeedStdev bin binno dno i trial trialno