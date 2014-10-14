% use this for adaptively finding threshold velocity, where the Peak and On
% thresholds are determined per calibration block

%% Count peaks

[trialno, binno, dno] = size(D.FrameDataExp.EyePosition);
MinFixation = 40;

CalibBlockSize = 150; CalibBlockNo = trialno/CalibBlockSize;
if iswhole(CalibBlockNo) == 0
    clc;
    error('\n\nERROR: Data does not have round number of blocks\n\n');
end

EyeSpeedCB = nan(CalibBlockNo,CalibBlockSize*binno,3);

for d = 1:dno
    EyeSpeedCB(:,:,d) = reshape(EyeSpeed(:,:,d)',CalibBlockSize*binno,CalibBlockNo)';
end

%EyeSpeedCB = zeronans(EyeSpeedCB);

SpeedThresPeakCB = [ones(CalibBlockNo,1), zeros(CalibBlockNo,1)];
SpeedThresOnCB = [ones(CalibBlockNo,1), zeros(CalibBlockNo,1)];

SaccadeEventNH = zeros(trialno,binno);
SaccadeCount = zeros(D.Trials,1);
SpeedThresOff = nan(D.Trials,20);

tic
for CalibBlock = 1:CalibBlockNo
    
    clc;
    fprintf('Savitzky-Golay filtering: Complete\n');
    fprintf('Saccade Detection: In Progress\n\n');
    fprintf('    Onset Threshold Detection: Block %d of %d\n',CalibBlock,CalibBlockNo);
    fprintf('    SaccadeEventNH Generation: Not Yet Started\n\n');
    fprintf('Direction Detection: Not Yet Started');
    
    
    SpeedThresPeakCB(CalibBlock,:) = SpeedThresPeakCB(CalibBlock,:)*50; %max(EyeSpeedCB(CalibBlock,:,3)-15);
    SpeedThresOnCB(CalibBlock,:) = SpeedThresOnCB(CalibBlock,:)*50; %max(EyeSpeedCB(CalibBlock,:,3)-15);
    
    %% find speed threshold for detecting saccade number (SpeedThresPeak)
    
    while abs(SpeedThresPeakCB(CalibBlock,1)-SpeedThresPeakCB(CalibBlock,2))...
            >= 0.005*SpeedThresPeakCB(CalibBlock,1)
        
        if SpeedThresPeakCB(CalibBlock,2) ~= 0
            SpeedThresPeakCB(CalibBlock,1:2) = [SpeedThresPeakCB(CalibBlock,2), 0];
        end
        
        EyeSpeed_lowCB = EyeSpeedCB;
        
        for bin = 1:binno*CalibBlockSize
            if EyeSpeed_lowCB(CalibBlock,bin,3) >= SpeedThresPeakCB(CalibBlock,1)
                EyeSpeed_lowCB(CalibBlock,bin,3) = nan;
            end
        end
        
        SpeedThresPeakCB(CalibBlock,2) = nanmean(EyeSpeed_lowCB(CalibBlock,:,3))...
            + 6*nanstd(EyeSpeed_lowCB(CalibBlock,:,3));
    end
    
    %% find speed threshold for saccade onset (SpeedThresOn)
    
    while abs(SpeedThresOnCB(CalibBlock,1)-SpeedThresOnCB(CalibBlock,2))...
            >= 0.005*SpeedThresOnCB(CalibBlock,1)
        
        if SpeedThresOnCB(CalibBlock,2) ~= 0
            SpeedThresOnCB(CalibBlock,1:2) = [SpeedThresOnCB(CalibBlock,2) 0];
        end
        
        EyeSpeed_lowCB = EyeSpeedCB;
        
        for bin = 1:binno*CalibBlockSize
            if EyeSpeed_lowCB(CalibBlock,bin,3) >= SpeedThresOnCB(CalibBlock,1)
                EyeSpeed_lowCB(CalibBlock,bin,3) = nan;
            end
        end
        
        SpeedThresOnCB(CalibBlock,2) = nanmean(EyeSpeed_lowCB(CalibBlock,:,3))...
            + 3*nanstd(EyeSpeed_lowCB(CalibBlock,:,3));
    end
    
end

SpeedThresPeak = ones(trialno,1);
SpeedThresOn = ones(trialno,1);

    %% fill SaccadeEventNH, inc. finding adaptive SpeedThresOff
   
for trial = 1:trialno
    
    clc;
    fprintf('Savitzky-Golay filtering: Complete\n');
    fprintf('Saccade Detection: In Progress\n\n');
    fprintf('    Onset Threshold Detection: Complete\n');
    fprintf('    SaccadeEventNH Generation: Trial %d of %d\n\n',trial,trialno);
    fprintf('Direction Detection: Not Yet Started');
    
    SpeedThresPeak(trial) = SpeedThresPeak(trial)*mean(SpeedThresPeakCB(ceil(trial/CalibBlockSize),:));
    SpeedThresOn(trial) = SpeedThresOn(trial)*mean(SpeedThresOnCB(ceil(trial/CalibBlockSize),:));
    
    SaccadeOn = 0; TooEarly = 0;
    
    for bin = 41:binno-1
        if EyeSpeed(trial,bin,3) >= SpeedThresPeak(trial) && ...
                EyeSpeed(trial,bin-1,3) < SpeedThresPeak(trial)
            
            SaccadeCount(trial) = SaccadeCount(trial) + 1;
            SaccadeOn = 1;
            binstart = bin;
            
            while EyeSpeed(trial,binstart,3) >= SpeedThresOn(trial) ||...
                    EyeSpeed(trial,binstart-1,3) <= EyeSpeed(trial,binstart,3)
                SaccadeEventNH(trial,binstart) = SaccadeOn;
                binstart = binstart - 1;
                
                if binstart <= MinFixation + 1 || sum(SaccadeEventNH(trial,binstart-MinFixation:binstart-1)) ~= 0
                    SaccadeEventNH(trial,binstart:bin) = zeros(1,length(binstart:bin));
                    SaccadeOn = 0;
                    SaccadeCount(trial) = SaccadeCount(trial) - 1;
                    TooEarly = 1;
                    break
                end
            end
            
            if TooEarly == 1
                TooEarly = 0;
                continue
            end

            SpeedThresOff(trial,SaccadeCount(trial)) = 0.7*SpeedThresOn(trial)...
                + 0.3*(nanmean(EyeSpeed(trial,binstart-40:binstart,3)) ...
                + 3*nanstd(EyeSpeed(trial,binstart-40:binstart,3)));
        end
        
        if SaccadeOn == 1 && ...
                EyeSpeed(trial,bin,3) <= SpeedThresOff(trial,SaccadeCount(trial)) && ...
                EyeSpeed(trial,bin,3) <= EyeSpeed(trial,bin+1,3)
            %if EyeSpeed(trial,bin,3) <= SpeedThresPeak(trial)
            SaccadeOn = 0;
            %end
        end
            
        SaccadeEventNH(trial,bin) = SaccadeOn;
        
    end
            
end

clc; fprintf('Complete\n\n');            

%% Cleanup

clear trial trialno bin binno dno EyeSpeed_low SaccadeOn TooEarly b binstart...
    completed elapsed g i
