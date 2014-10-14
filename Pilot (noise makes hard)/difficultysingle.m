function [DifficultyStats,StatsRef] = difficulty(D)

%% Find percentage of failed trials

FailRate = (1 - sum(D.TargetHit)/D.Trials) * 100;

%% Find length of successful trials

HitTime = D.HitTime;

for trial = 1:length(HitTime)
    if HitTime(trial) > max(D.TrialDuration)
        HitTime(trial) = nan;
    end
end

HitTimeMean = nanmean(HitTime);
HitTimeSTD = nanstd(HitTime);

%% Find number of saccades

% should I discount failed trials?

SaccadeEvent = D.FrameDataExp.SaccadeEvent; %might change this

[trialno,binno] = size(SaccadeEvent);
SaccadeCount = zeros(trialno,1);

for trial = 1:trialno
    
    %if D.TargetHit(trial) == 1
    
        for bin = 2:binno
            if SaccadeEvent(trial,bin) - SaccadeEvent(trial,bin-1) == 1
                SaccadeCount(trial,1) = SaccadeCount(trial,1) + 1;
            end
        end
        
    %end
    
end

SaccadeCountMean = mean(SaccadeCount);
SaccadeCountSTD = std(SaccadeCount);

DifficultyStats = ...
    [FailRate;
    HitTimeMean;
    HitTimeSTD;
    SaccadeCountMean;
    SaccadeCountSTD];

StatsRef = ...
   {'FailRate';
    'HitTimeMean';
    'HitTimeSTD';
    'SaccadeCountMean';
    'SaccadeCountSTD'};

end
