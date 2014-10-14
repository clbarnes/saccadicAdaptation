% use this for testing given values

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

if ATtrial == 1
%% Calculate speed (raw and smooth)

EyeSpeedRaw = speedcalc_2(EyePosition,TrialTime);
for i = 1:3
EyeSpeed(:,:,i) = smoothMag(EyeSpeedRaw(:,:,i),WindowSize);
end

%% Calculate acceleration (raw and smooth)

EyeAccelRaw = accelcalc_2(EyeSpeed,TrialTime);
for i = 1:3
EyeAccel(:,:,i) = smoothMag(EyeAccelRaw(:,:,i),WindowSize);
end

end

%% Run saccade detector

saccadedetector_5;

%% Plot graphs

% Count saccades over criterion length

Saccno = length(SaccLength);
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

clear EyeAccelRaw EyeSpeedRaw L...
    Ptrial Ptrialno Sacc SaccEnd SaccStart...
    Saccno StableAccelerationMean...
    WindowSize

%% Cleanup

clear trial trialno bin binno dno
