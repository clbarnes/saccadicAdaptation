

%% Find percentage of failed trials

FailRate = (1 - sum(TargetHitC)/D.Trials) * 100;

%% Find length of successful trials

%HitTime = D.HitTime;

for trial = 1:length(HitTimeC)
    if HitTimeC(trial) > max(D.TrialDuration) ...
            || sum(diff(D.FrameDataExp.TargetPosition(trial, ...
            1:end-find(fliplr(D.FrameDataExp.EyePosition(trial,:,1)),1),1))) == 0
        HitTimeC(trial) = nan;
    end
end

HitTimeCMean = nanmean(HitTimeC);
HitTimeCSTD = nanstd(HitTimeC);

%% Find number of saccades

% should I discount failed trials?

SaccadeEvent = D.FrameDataExp.SaccadeEvent; %might change this

[trialno,binno] = size(SaccadeEvent);
SaccadeCount = zeros(trialno);

for trial = 1:trialno
    
    %if D.TargetHit(trial) == 1
    
        for bin = 2:binno
            if isnan(HitTimeC(trial)) == 1
                SaccadeCount(trial) = nan;
            elseif SaccadeEvent(trial,bin) - SaccadeEvent(trial,bin-1) == 1
                SaccadeCount(trial) = SaccadeCount(trial) + 1;
            end
        end  
    %end  
end

SaccadeCountMean = nanmean(SaccadeCount);
SaccadeCountSTD = nanstd(SaccadeCount);

clear trial trialno bin binno dno