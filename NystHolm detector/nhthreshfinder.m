% use this for adaptively finding threshold velocity

%% Count peaks

[trialno, binno, dno] = size(D.FrameDataExp.EyePosition);

SpeedThresPeak = [ones(D.Trials,1), zeros(D.Trials,1)];
SpeedThresOn = [ones(D.Trials,1), zeros(D.Trials,1)];
SaccadeEventNH = zeros(trialno,binno);
SaccadeCount = zeros(D.Trials,1);
SpeedThresOff = nan(D.Trials,20);

tic
for trial = 1:trialno

    i = 0; SaccadeOn = 0; TooEarly = 0;
    
    clc;
    fprintf('Savitzky-Golay filtering: Complete\n');
    fprintf('Saccade Detection: In Progress\n\n');
    fprintf('    Trial %d of %d\n',trial,trialno);
    fprintf('    %d%% complete\n',floor((trial/trialno)*100));
    fprintf('    Less than %d minutes remaining\n',ceil(((toc/(trial/trialno))-toc)/60));
    
    SpeedThresPeak(trial,:) = SpeedThresPeak(trial,:)*max(EyeSpeed(trial,:,3)-15);
    SpeedThresOn(trial,:) = SpeedThresOn(trial,:)*max(EyeSpeed(trial,:,3)-15);
    
    %% find speed threshold for detecting saccade number (SpeedThresPeak)
    
    while abs(SpeedThresPeak(trial,1)-SpeedThresPeak(trial,2)) >= 0.005*SpeedThresPeak(trial,1)
        i = i+1;
        
        if SpeedThresPeak(trial,2) ~= 0
            SpeedThresPeak(trial,1:2) = [SpeedThresPeak(trial,2) 0];
        end
        
        EyeSpeed_low = EyeSpeed;
        
        for bin = 1:binno
            if EyeSpeed_low(trial,bin,3) >= SpeedThresPeak(trial,1)
                EyeSpeed_low(trial,bin,3) = nan;
            end
        end
        
        SpeedThresPeak(trial,2) = nanmean(EyeSpeed_low(trial,:,3))...
            + 4*nanstd(EyeSpeed_low(trial,:,3));
    end
    
    %% find speed threshold for saccade onset (SpeedThresOn)
    
    while abs(SpeedThresOn(trial,1)-SpeedThresOn(trial,2)) >= 0.005*SpeedThresOn(trial,1)
        i = i+1;
        
        if SpeedThresOn(trial,2) ~= 0
            SpeedThresOn(trial,1:2) = [SpeedThresOn(trial,2) 0];
        end
        
        EyeSpeed_low = EyeSpeed;
        
        for bin = 1:binno
            if EyeSpeed_low(trial,bin,3) >= SpeedThresOn(trial,1)
                EyeSpeed_low(trial,bin,3) = nan;
            end
        end
        
        SpeedThresOn(trial,2) = nanmean(EyeSpeed_low(trial,:,3))...
            + 3*nanstd(EyeSpeed_low(trial,:,3));
    end
    
    %% fill SaccadeEventNH, inc. finding adaptive SpeedThresOff
    
    for bin = 41:binno-1
        if EyeSpeed(trial,bin,3) >= SpeedThresPeak(trial,2) && ...
                EyeSpeed(trial,bin-1,3) < SpeedThresPeak(trial,2)
            
            SaccadeCount(trial) = SaccadeCount(trial) + 1;
            SaccadeOn = 1;
            binstart = bin;
            
            while EyeSpeed(trial,binstart,3) >= SpeedThresOn(trial,2)
                SaccadeEventNH(trial,binstart) = SaccadeOn;
                binstart = binstart - 1;
                
                if binstart <= 41 || sum(SaccadeEventNH(trial,binstart-40:binstart-1)) ~= 0
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

            SpeedThresOff(trial,SaccadeCount(trial)) = 0.7*SpeedThresOn(trial,2)...
                + 0.3*(nanmean(EyeSpeed(trial,binstart-40:binstart,3)) ...
                + 3*nanstd(EyeSpeed(trial,binstart-40:binstart,3)));
        end
        
        if SaccadeOn == 1 && ...
                EyeSpeed(trial,bin,3) <= SpeedThresOff(trial,SaccadeCount(trial)) || ...
                EyeSpeed(trial,bin,3) <= EyeSpeed(trial,bin+1,3)
            if EyeSpeed(trial,bin,3) <= SpeedThresPeak(trial,2)
            SaccadeOn = 0;
            end
        end
            
        SaccadeEventNH(trial,bin) = SaccadeOn;
        
    end
            
end

clc; fprintf('Complete\n\n');            

%% Cleanup

clear trial trialno bin binno dno EyeSpeed_low SaccadeOn TooEarly b binstart...
    completed elapsed g i
