% use this for finding optimal values

%% Extract variables
EyePosition = D.FrameDataExp.EyePosition; [trialno, binno, dno] = size(EyePosition);
EyePosition = dispcalc(EyePosition);
BlinkEvent = D.FrameDataExp.BlinkEvent; 
TrialTime = D.FrameDataExp.TrialTime;
GazeStable = D.FrameDataExp.GazeStable;

%% Define variables
%WindowSize = 9;
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

WindowSizeMin = 1; % DON'T CHANGE THIS
WindowSizeMax = 15;

tic

for WindowSize = WindowSizeMin:WindowSizeMax

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

adaptspeedthresfinder;

saccadedetector_4;

%% Plot graphs

[ATtrialno,Saccno] = size(SaccLength);

%SaccErrorPC = zeros(Ptrialno,WindowSizeMax);
L = 0.012; %seconds

for ATtrial = 1:ATtrialno
    for Sacc = 1:Saccno
        if SaccLength(ATtrial,Sacc) == 0
            SaccLength(ATtrial,Sacc) = nan;
        end
    end
end

for ATtrial = 1:ATtrialno    
    SaccErrorPC(ATtrial,WindowSize) = (BadSaccCount(ATtrial,WindowSize) /...
        (BadSaccCount(ATtrial,WindowSize)+TrueSaccCount(ATtrial,WindowSize)))*100;
end

end

save lastminute_2

%% Find WindowSize + P combination at which certain error level is reached earliest

Error = 5; %percent
%Prange = fliplr(Prange);
OptimalAT = zeros(1,length(WindowSizeMin:WindowSizeMax));
OptimSaccCount = zeros(1,length(WindowSizeMin:WindowSizeMax));
AccelThreshes = [200:200:5000];

for WindowSize = WindowSizeMin:WindowSizeMax
    for ATtrial = length(AccelThreshes)-1:-1:1
        if SaccErrorPC(ATtrial,WindowSize) >= Error
            if SaccErrorPC(ATtrial+1,WindowSize) < Error
                OptimalAT(WindowSize) = ...
                    mean([AccelThreshes(1,ATtrial) AccelThreshes(1,ATtrial+1)]);
                OptimSaccCount(WindowSize) = TrueSaccCount(ATtrial,WindowSize);
            end
        end
    end
end

figure, plot3(WindowSizeMin:WindowSizeMax,OptimalAT(1:WindowSizeMax),OptimSaccCount);...
    ylabel('Optimal Accel Threshold (\sigma)'); xlabel('WindowSize (ms)'); zlabel('TrueSaccCount');

%% Cleanup

clear trial trialno bin binno dno
