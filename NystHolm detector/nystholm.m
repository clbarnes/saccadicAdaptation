% Analyse data from experiment

%% Initialise variables

D = input('Which Data Set? \n');
dataname = input('Name of Subject Data:\n');

[trialno, binno, dno] = size(D.FrameDataExp.EyePosition);

TrialBlockSize = 50; TrialBlockNo = trialno/TrialBlockSize;

if iswhole(TrialBlockNo) == 0
    error('\n\nERROR: Data does not have round number of blocks\n\n');
end

%% Perform Nystrom-Holmqvist analysis

nhsmooth;

nhthreshfinder2;

[BadDisplayOffsets,DoDisplayShift] = catchbadoffsets(D,SaccadeEventNH);

%% Find all saccades, their start points, end points, direction and size

nhdirection;

clc;
fprintf('Savitzky-Golay filtering: Complete\n');
fprintf('Saccade Detection: Complete\n');
fprintf('Direction Detection: Complete\n\n');
fprintf('Concatenating Directions...\n');

NE_SE_SW_NW = zeros(TrialBlockNo,4);

for TrialBlock = 1:TrialBlockNo
    NE_SE_SW_NW(TrialBlock,:) = directioncount(SaccDirection((TrialBlock-1)*TrialBlockSize+1:TrialBlock*TrialBlockSize,:));
end

QuadrantsPC = nan(TrialBlockNo,4);

for TrialBlock = 1:TrialBlockNo
    for TrialQuadrant = 1:4
        QuadrantsPC(TrialBlock,TrialQuadrant) = ...
            (NE_SE_SW_NW(TrialBlock,TrialQuadrant)/sum(NE_SE_SW_NW(TrialBlock,:)))*100;
    end
end

SaccSize = saccsize(SaccStart,SaccEnd,TrialBlockSize);

%Reshape SaccDirection to use trial blocks
SaccDirectionBlock = nan(TrialBlockNo,TrialBlockSize*25);
SaccStartBlock = nan(TrialBlockNo,TrialBlockSize*25);
SaccEndBlock = nan(TrialBlockNo,TrialBlockSize*25);

for TrialBlock = 1:TrialBlockNo
    SaccCounter = 0;
    for trial = (TrialBlock-1)*TrialBlockSize+1:TrialBlock*TrialBlockSize
        for sacc = 1:25
            if isnan(SaccDirection(trial,sacc)) == 1
                break
            end
            
            SaccCounter = SaccCounter + 1;
            
            SaccDirectionBlock(TrialBlock,SaccCounter) = SaccDirection(trial,sacc);
            SaccStartBlock(TrialBlock,SaccCounter) = SaccStart(trial,sacc);
            SaccEndBlock(TrialBlock,SaccCounter) = SaccEnd(trial,sacc);
        end
    end
end

[SaccSizebyDirection,SaccSizebyDirectionMean,SaccSizebyDirectionSTD] = saccsizebydirection(SaccSize,SaccDirectionBlock);

%% Assess difficulty of trials

[DifficultyStats,StatsRef] = difficulty(D,TrialBlockSize);

%% Package data

clc;
fprintf('Centralising Data: Raw')
eval([dataname '.D = D;']);

clc;
fprintf('Centralising Data: Trial Profiles')
eval([dataname '.EyeAccel = EyeAccel;']);
eval([dataname '.EyeSpeed = EyeSpeed;']);
eval([dataname '.EyePositionS = EyePositionS;']);
eval([dataname '.DifficultyStats = DifficultyStats;']);
eval([dataname '.StatsRef = StatsRef;']);
eval([dataname '.DoDisplayShift = DoDisplayShift;']);
eval([dataname '.BadDisplayOffsets = BadDisplayOffsets;']);

clc;
fprintf('Centralising Data: Direction')
eval([dataname '.NE_SE_SW_NW = NE_SE_SW_NW;']);
eval([dataname '.QuadrantsPC = QuadrantsPC;']);

clc;
fprintf('Centralising Data: Saccades')
eval([dataname '.SaccCount = SaccCount;']);
eval([dataname '.SaccDirection = SaccDirection;']);
eval([dataname '.SaccDirectionBlock = SaccDirectionBlock;']);
eval([dataname '.SaccEnd = SaccEnd;']);
eval([dataname '.SaccEndBlock = SaccEndBlock;']);
eval([dataname '.SaccStart = SaccStart;']);
eval([dataname '.SaccStartBlock = SaccStartBlock;']);
eval([dataname '.SaccadeEventNH = SaccadeEventNH;']);
eval([dataname '.SaccSize = SaccSize;']);
eval([dataname '.SaccSizebyDirection = SaccSizebyDirection;']);
eval([dataname '.SaccSizebyDirectionMean = SaccSizebyDirectionMean;']);
eval([dataname '.SaccSizebyDirectionSTD = SaccSizebyDirectionSTD;']);

clc;
fprintf('Centralising Data: Thresholds')
eval([dataname '.SpeedThresPeak = SpeedThresPeak;']);
eval([dataname '.SpeedThresPeakCB = SpeedThresPeakCB;']);
eval([dataname '.SpeedThresOn = SpeedThresOn;']);
eval([dataname '.SpeedThresOnCB = SpeedThresOnCB;']);
eval([dataname '.SpeedThresOff = SpeedThresOff;']);


%% Clean up

clc;
fprintf('Saving Data... ')

eval(['clearvars -except dataname ' dataname]);

eval(['save ' dataname]);

fprintf('Complete.\n\n');