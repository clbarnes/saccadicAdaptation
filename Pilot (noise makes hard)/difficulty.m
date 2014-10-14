function [DifficultyStats,StatsRef] = difficulty(D,TrialBlockSize)

TrialBlockNo = D.Trials/TrialBlockSize;

if iswhole(TrialBlockNo) == 0
    error('Number of Trial Blocks not whole');
end

FailRate = zeros(TrialBlockNo,1);
HitTimeMean = zeros(TrialBlockNo,1);
HitTimeSTD = zeros(TrialBlockNo,1);
SaccadeCountMean = zeros(TrialBlockNo,1);
SaccadeCountSTD = zeros(TrialBlockNo,1);

for TrialBlock = 1:TrialBlockNo
    
    %% Find percentage of failed trials
    
    FailRate(TrialBlock,1) = (1 - sum(D.TargetHit...
        ((TrialBlock-1)*TrialBlockSize+1:TrialBlock*TrialBlockSize,1))/TrialBlockSize) * 100;
    
    %% Find length of successful trials
    
    HitTime = D.HitTime((TrialBlock-1)*TrialBlockSize+1:TrialBlock*TrialBlockSize,1);
    
    for trial = 1:length(HitTime)
        if HitTime(trial) > max(D.TrialDuration)
            HitTime(trial) = nan;
        end
    end
    
    HitTimeMean(TrialBlock,1) = nanmean(HitTime);
    HitTimeSTD(TrialBlock,1) = nanstd(HitTime);
    
    %% Find number of saccades
    
    % should I discount failed trials?
    
    SaccadeEvent = D.FrameDataExp.SaccadeEvent; %might change this
    [trialno,binno] = size(D.FrameDataExp.SaccadeEvent);
    
    SaccadeCount = zeros(TrialBlockSize,1);
    
    for trial = (TrialBlock-1)*TrialBlockSize+1:TrialBlock*TrialBlockSize
        
        %if D.TargetHit(trial) == 1
        
        for bin = 2:binno
            if SaccadeEvent(trial,bin) - SaccadeEvent(trial,bin-1) == 1
                SaccadeCount(trial-((TrialBlock-1)*TrialBlockSize),1) = SaccadeCount(trial-((TrialBlock-1)*TrialBlockSize),1) + 1;
            end
        end
        
        %end
        
    end
    
    SaccadeCountMean(TrialBlock,1) = mean(SaccadeCount);
    SaccadeCountSTD(TrialBlock,1) = std(SaccadeCount);
    
end

DifficultyStats = ...
    [FailRate, HitTimeMean, HitTimeSTD, SaccadeCountMean, SaccadeCountSTD];

StatsRef = ...
    {'FailRate','HitTimeMean','HitTimeSTD','SaccadeCountMean','SaccadeCountSTD'};

end
