% This picks up the number of saccades made in trials judged successful by
% the Exp, and in trials judged successful by redetectpassfail.

[trialno,binno,dno] = size(D.FrameDataExp.EyePosition);

DetectedCount = 0; UndetectedCount = 0;

DetectedSaccadeCount = zeros(sum(D.TargetHit),1);
UndetectedSaccadeCount = zeros(sum(TargetHitC-D.TargetHit),1);

for trial = 1:trialno
    if D.TargetHit(trial) == 1
        DetectedCount = DetectedCount + 1;
        for bin = 2:binno
            if D.FrameDataExp.SaccadeEvent(trial,bin) == 1 && ...
                    D.FrameDataExp.SaccadeEvent(trial,bin-1) == 0
                DetectedSaccadeCount(DetectedCount) = DetectedSaccadeCount(DetectedCount) + 1;
            end
        end
    end
    
    if D.TargetHit(trial) == 0 && TargetHitC(trial) == 1
        UndetectedCount = UndetectedCount + 1;
        for bin = 2:binno
            if D.FrameDataExp.SaccadeEvent(trial,bin) == 1 && ...
                    D.FrameDataExp.SaccadeEvent(trial,bin-1) == 0
                UndetectedSaccadeCount(UndetectedCount) = UndetectedSaccadeCount(UndetectedCount) + 1;
            end
        end
    end
end

h = ttest2(DetectedCount,UndetectedCount)

        
    