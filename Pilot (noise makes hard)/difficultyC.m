function [DifficultyStats,StatsRef] = difficultyC(D)

fixeddetector;

%% Find percentage of failed trials

FailRate = (1 - sum(TargetHitC)/D.Trials) * 100;

%% Find length of successful trials

HitTimeMean = nanmean(HitTimeC);
HitTimeSTD = nanstd(HitTimeC);

SaccadeCountMean = mean(SaccadeCountC);
SaccadeCountSTD = std(SaccadeCountC);

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
