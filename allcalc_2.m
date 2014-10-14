% use this for testing a given WS and P value

%% Extract variables
EyePosition = D.FrameDataExp.EyePosition; [trialno, binno, dno] = size(EyePosition);
EyePosition = dispcalc(EyePosition);
BlinkEvent = D.FrameDataExp.BlinkEvent; 
TrialTime = D.FrameDataExp.TrialTime;
GazeStable = D.FrameDataExp.GazeStable;

%% Define variables
WindowSize = 9;
BlinkWindow = 30;

% StableAccelerationStdev = 7000;
% StableSpeedStdev = 4.5;
% StableSpeedMean = 3.7;
% 
% SpeedThresh = StableSpeedMean + StableSpeedStdev * 1;
% AccelThresh = StableAccelerationStdev * 1;

%% nan during Blinks, after trial end

for trial = 1:trialno
    for bin = 1:binno-BlinkWindow
        if sum(BlinkEvent(trial,bin:bin+BlinkWindow)) >= 1
            EyePosition(trial,bin:bin+BlinkWindow,:) = nan;
        end
    end
end

clear BlinkWindow;

for trial = 1:trialno
    for bin = 1:binno
        if TrialTime(trial,bin) == 0
            EyePosition(trial,bin,:) = nan;
        end
    end
end

%% Calculate speed (raw and smooth)

EyeSpeedRaw = speedcalc_2(EyePosition,TrialTime);
for i = 1:3
EyeSpeed(:,:,i) = smoothMag(EyeSpeedRaw(:,:,i),WindowSize);
end
   % EyeSpeed(:,:,3) = abs(EyeSpeed(:,:,3));

%% Calculate acceleration (raw and smooth)

EyeAccelRaw = accelcalc_2(EyeSpeed,TrialTime);
for i = 1:3
EyeAccel(:,:,i) = smoothMag(EyeAccelRaw(:,:,i),WindowSize);
end

%% Run saccade detector

saccadedetector_3;

%% Plot graphs

% Count saccades over criterion length

[Ptrialno,Saccno] = size(SaccLength);
TrueSaccCount = 0;
BadSaccCount = 0;
%SaccErrorPC = zeros(Ptrialno,WindowSizeMax);
L = 0.012; %seconds

for Sacc = 1:Saccno
    if SaccLength(Sacc) == 0
        SaccLength(Sacc) = nan;
    end
end

for Sacc = 1:Saccno
    if SaccLength(Sacc) >= L
        TrueSaccCount = TrueSaccCount + 1;
    end
    
    if SaccLength(Sacc) <= L
        BadSaccCount = BadSaccCount + 1;
    end
end
    
SaccErrorPC = (BadSaccCount /...
    (BadSaccCount + TrueSaccCount))*100;

% figure, subplot(2,1,2), semilogy(Prange,SaccErrorPC(:,WindowSize));...
%     title('Percentage of detected eye movements below criterion duration');...
%     ylim([0 100]); xlabel('P'); ylabel('% (logarithmic)')
% subplot(2,1,1), plot(Prange,TrueSaccCount(:,WindowSize) + BadSaccCount(:,WindowSize));...
%     xlim([min(Prange) max(Prange)]); ylabel('Saccades detected');

clear EyeAccelRaw EyeSpeedRaw L...
    Ptrial Ptrialno Sacc SaccEnd SaccLength SaccStart...
    Saccno StableAccelerationMean...
    WindowSize

%% Find Accel + Speed profiles of stable regions

% EyeAccelStable = EyeAccel;
% EyeSpeedStable = EyeSpeed;
% EyePositionStable = EyePosition;
% 
% for trial = 1:trialno
%     for bin = 1:binno
%         if GazeStable(trial,bin) == 0
%             EyeAccelStable(trial,bin,:) = nan;
%             EyeSpeedStable(trial,bin,:) = nan;
%             EyePositionStable(trial,bin,:) = nan;
%         end
%     end
% end

%% Cleanup

clear trial trialno bin binno dno
