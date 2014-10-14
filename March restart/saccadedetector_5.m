%to go with allcalc_4

[trialno,binno,dno] = size(EyePosition);
SaccadeEventC = zeros(trialno,binno);
SaccadeCount = 0;

SpeedThresh = 16.5;
AccelThresh = 1600;
MinFixate = 100;

for trial = 1:trialno
    SaccEndBin = -MinFixate;
    for bin = 2:binno
        if bin > SaccEndBin + MinFixate
            if EyeSpeed(trial,bin,3) >= SpeedThresh
                if EyeAccel(trial,bin,3) >= AccelThresh
                    SaccadeEventC(trial,bin) = 1;
                end
            end
        end
        
        if SaccadeEventC(trial,bin-1) == 1
            if EyeSpeed(trial,bin,3) > SpeedThresh
                SaccadeEventC(trial,bin) = 1;
                if EyeAccel(trial,bin-1,3) < 0
                    if EyeAccel(trial,bin,3) > 0
                        SaccadeEventC(trial,bin) = 0;
                    end
                end
            end
            if SaccadeEventC(trial,bin) == 0
                SaccEndBin = bin;
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