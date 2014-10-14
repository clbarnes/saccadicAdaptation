%% per trial
SaccFreq = nan(900,1);

for trial = 1:900
    SaccFreq(trial) = ...
        SaccCount(trial)/TrialDuration(trial);
end

SaccFreqMean = mean(SaccFreq);
SaccFreqSTD = std(SaccFreq);

%% per block

SaccCountBlock = zeros(18,1);
TrialDurationBlock = zeros(18,1);

for TrialBlock = 1:18
    for trial = (TrialBlock-1)*50+1:TrialBlock*50
        SaccCountBlock(TrialBlock) = SaccCountBlock(TrialBlock)+SaccCount(trial);
        TrialDurationBlock(TrialBlock) = TrialDurationBlock(TrialBlock)+TrialDuration(trial);
    end
end

SaccFreqBlock = nan(18,1);

for TrialBlock = 1:18
    SaccFreqBlock(TrialBlock) = SaccCountBlock(TrialBlock)/TrialDurationBlock(TrialBlock);
end

%% per block, keeping individuals separate

for i = 1:5
    if i == 3
        continue
    end
    
    eval(['SaccCountBlock_' num2str(i) ' = zeros(18,1);']);
    eval(['TrialDurationBlock_' num2str(i) ' = zeros(18,1);']);
    eval(['SaccFreqBlock_' num2str(i) ' = zeros(18,1);']);
    
    for TrialBlock = 1:18
        for trial = (TrialBlock-1)*50+1:TrialBlock*50
            eval(['SaccCountBlock_' num2str(i) '(TrialBlock) = SaccCountBlock_' num2str(i) '(TrialBlock)+SaccCount_' num2str(i) '(trial);' ...
                'TrialDurationBlock_' num2str(i) '(TrialBlock) = TrialDurationBlock_' num2str(i) '(TrialBlock)+TrialDuration_' num2str(i) '(trial);']);
        end
        eval(['SaccFreqBlock_' num2str(i) '(TrialBlock) = SaccCountBlock_' num2str(i) '(TrialBlock)/TrialDurationBlock_' num2str(i) '(TrialBlock);']);
    end
end

SaccCountAll = [SaccCountBlock_1 SaccCountBlock_2 SaccCountBlock_4 SaccCountBlock_5];
TrialDurationAll = [TrialDurationBlock_1 TrialDurationBlock_2 TrialDurationBlock_4 TrialDurationBlock_5];
SaccFreqAll = [SaccFreqBlock_1 SaccFreqBlock_2 SaccFreqBlock_4 SaccFreqBlock_5];