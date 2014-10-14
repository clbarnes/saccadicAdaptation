%to go with allcalc_4

[trialno,binno,dno] = size(EyePosition);
SaccadeEventC = zeros(trialno,binno);


MinFixate = 100;

if WindowSize == 1
TrueSaccCount = zeros(30,15);
BadSaccCount = zeros(30,15);
SaccadeCount = zeros(30,15);
end

ATtrial = 0;

for AccelThresh = 500:500:15000;
    
    ATtrial = ATtrial + 1;

for trial = 1:trialno
    SaccEndBin = -MinFixate;
    for bin = 2:binno
        if bin > SaccEndBin + MinFixate
            if EyeSpeed(trial,bin,3) >= SpeedThresh(1,WindowSize)
                if EyeAccel(trial,bin,3) >= AccelThresh
                    SaccadeEventC(trial,bin) = 1;
                end
            end
        end
        
        if SaccadeEventC(trial,bin-1) == 1
            if EyeSpeed(trial,bin,3) > SpeedThresh(1,WindowSize)
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
                    SaccadeCount(ATtrial,WindowSize) =...
                        SaccadeCount(ATtrial,WindowSize) + 1;
                    SaccLength = SaccEnd - SaccStart;
                    if SaccLength >= 0.012
                        TrueSaccCount(ATtrial,WindowSize) =...
                            TrueSaccCount(ATtrial,WindowSize)+1;
                    else
                        BadSaccCount(ATtrial,WindowSize) =...
                            BadSaccCount(ATtrial,WindowSize)+1;
                    end
                end
            end
        end
        
    end
end

SaccadeEventC = zeros(trialno,binno);

end


%% Cleanup
clear P StableAccelerationStdev ...
    StableSpeedMean StableSpeedStdev bin binno dno i trial trialno