TargetHitWindowSeconds = 0.3;
TargetTolerance = 1.5;
D = input('Which Data Set? \n');

[trialno,binno,dno] = size(D.FrameDataExp.EyePosition);

HitTimeC = nan(trialno,1);
TargetHitC = zeros(trialno,1);
SaccadeCountC = zeros(trialno,1);

TargetHitTime = [];

for trial = 1:trialno
    for bin = 2:binno
        
        if TargetHitC(trial) == 1
            continue
        end
        
        if D.FrameDataExp.SaccadeEvent(trial,bin) == 1 && ...
                D.FrameDataExp.SaccadeEvent(trial,bin-1) == 0
            SaccadeCountC(trial) = SaccadeCountC(trial) + 1;
        end
        
        if abs(D.FrameDataExp.EyePosition(trial,bin,1) - D.FrameDataExp.TargetPosition(trial,bin,1)) <= TargetTolerance &&...
                abs(D.FrameDataExp.EyePosition(trial,bin,2) - D.FrameDataExp.TargetPosition(trial,bin,2)) <= TargetTolerance
            
            TargetHitTime = [TargetHitTime D.FrameDataExp.TrialTime(trial,bin)];
            
            if TargetHitTime(end) - TargetHitTime(1) >= TargetHitWindowSeconds
                HitTimeC(trial) = D.FrameDataExp.TrialTime(trial,bin);
                TargetHitC(trial) = 1;
            end
            
        else
            TargetHitTime = [];
        end
        
    end
end

clear trialno binno dno trial bin TargetTolerance TargetHitWindowSeconds