% % use this for adaptively finding threshold velocity
% 
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

%% 
AccelThres = [20000,0]; i = 0;

[trialno, binno, dno] = size(EyeAccel);

while abs(AccelThres(1,1)-AccelThres(1,2)) >= 0.005*AccelThres(1,1)
    
    i = i+1;
    clc; 
    
    fprintf('Iteration %d\n',i);
    fprintf('%d%% change in threshold\n',(abs(AccelThres(1,1)-AccelThres(1,2))...
        /AccelThres(1,1))*100)
    
    if AccelThres(1,2) ~= 0
        AccelThres = [AccelThres(1,2) 0];
    end
    
    
    EyeAccel_low = EyeAccel;
    
    for trial = 1:trialno
        for bin = 1:binno
            if EyeAccel_low(trial,bin,3) < 0
                EyeAccel_low(trial,bin,3) = nan;
            end
            if EyeAccel_low(trial,bin,3) >= AccelThres(1,1)
                EyeAccel_low(trial,bin,3) = nan;
            end
        end
    end
    
    AccelThres(1,2) = nanmean2(EyeAccel_low(:,:,3))...
        + 3*nanstd2(EyeAccel_low(:,:,3));
end
            

%% Cleanup

clear trial trialno bin binno dno
