% use this for adaptively finding threshold velocity

% %% Extract variables
% EyePosition = D.FrameDataExp.EyePosition; [trialno, binno, dno] = size(EyePosition);
% EyePosition = dispcalc(EyePosition);
% BlinkEvent = D.FrameDataExp.BlinkEvent; 
% TrialTime = D.FrameDataExp.TrialTime;
% GazeStable = D.FrameDataExp.GazeStable;
% SaccadeEvent = D.FrameDataExp.SaccadeEvent;
% 
% %% Define variables
% WindowSize = 9;
% BlinkWindow = 30;
% 
% %% nan during Blinks, after trial end
% 
% for trial = 1:trialno
%     for bin = 1:binno-BlinkWindow
%         if sum(BlinkEvent(trial,bin:bin+BlinkWindow)) >= 1
%             EyePosition(trial,bin:bin+BlinkWindow,:) = nan;
%         end
%     end
% end
% 
% clear BlinkWindow;
% 
% for trial = 1:trialno
%     for bin = 1:binno
%         if TrialTime(trial,bin) == 0
%             EyePosition(trial,bin,:) = nan;
%         end
%     end
% end
% 
% %% Calculate speed (raw and smooth)
% 
% EyeSpeedRaw = speedcalc_2(EyePosition,TrialTime);
% %EyeSpeed = smoothC(EyeSpeedRaw,WindowSize);
% EyeSpeed = smoothSG(EyeSpeedRaw);
%     EyeSpeed(:,:,3) = abs(EyeSpeed(:,:,3));
%     
% 
% %% Calculate acceleration (raw and smooth)
% 
% % EyeAccelRaw = speedcalc_2(EyeSpeed,TrialTime);
% % EyeAccel = smoothC(EyeAccelRaw,WindowSize);

%% Count peaks
SpeedThres = [100,0]; i = 0;

[trialno, binno, dno] = size(EyeSpeed);

while abs(SpeedThres(1,1)-SpeedThres(1,2)) >= 0.005*SpeedThres(1,1)
    
    i = i+1;
    clc; 
    
    fprintf('Window Size %d\n',WindowSize);
    fprintf('Iteration %d\n',i);
    fprintf('%d%% change in threshold\n',(abs(SpeedThres(1,1)-SpeedThres(1,2))...
        /SpeedThres(1,1))*100)
    
    if SpeedThres(1,2) ~= 0
        SpeedThres = [SpeedThres(1,2) 0];
    end
    
    EyeSpeed_low = abs(EyeSpeed);
    
    for trial = 1:trialno
        for bin = 1:binno
            if EyeSpeed_low(trial,bin,3) >= SpeedThres(1,1)
                EyeSpeed_low(trial,bin,3) = nan;
            end
        end
    end
    
    SpeedThres(1,2) = nanmean2(EyeSpeed_low(:,:,3))...
        + 3*nanstd2(EyeSpeed_low(:,:,3));
end

SpeedThresh(1,WindowSize) = ceil(SpeedThres(1,2));
            

%% Cleanup

clear trial trialno bin binno dno
