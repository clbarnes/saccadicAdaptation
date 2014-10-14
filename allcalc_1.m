% use this for finding optimal P and WS values

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

saccadedetector_2;

%% Plot graphs

[Ptrialno,Saccno] = size(SaccLength);
if WindowSize == 1
TrueSaccCount = zeros(Ptrialno,WindowSizeMax);
BadSaccCount = zeros(Ptrialno,WindowSizeMax);
end

%SaccErrorPC = zeros(Ptrialno,WindowSizeMax);
L = 0.012; %seconds

for Ptrial = 1:Ptrialno
    for Sacc = 1:Saccno
        if SaccLength(Ptrial,Sacc) == 0
            SaccLength(Ptrial,Sacc) = nan;
        end
    end
end

for Ptrial = 1:Ptrialno
    for Sacc = 1:Saccno
        if SaccLength(Ptrial,Sacc) >= L
            TrueSaccCount(Ptrial,WindowSize) = TrueSaccCount(Ptrial,WindowSize) + 1;
        end

        if SaccLength(Ptrial,Sacc) <= L
            BadSaccCount(Ptrial,WindowSize) = BadSaccCount(Ptrial,WindowSize) + 1;
        end
    end
    
    SaccErrorPC(Ptrial,WindowSize) = (BadSaccCount(Ptrial,WindowSize) /...
        (BadSaccCount(Ptrial,WindowSize)+TrueSaccCount(Ptrial,WindowSize)))*100;
end

% figure, subplot(2,1,2), semilogy(Prange,SaccErrorPC(:,WindowSize));...
%     title('Percentage of detected eye movements below criterion duration');...
%     ylim([0 100]); xlabel('P'); ylabel('% (logarithmic)')
% subplot(2,1,1), plot(Prange,TrueSaccCount(:,WindowSize) + BadSaccCount(:,WindowSize));...
%     xlim([min(Prange) max(Prange)]); ylabel('Saccades detected');

clear EyeAccel EyeAccelRaw EyeSpeed EyeSpeedRaw L...
    Ptrial Ptrialno Sacc SaccEnd SaccLength SaccPpn SaccPpnW SaccStart...
    SaccadeEventC Saccno StableAccelerationMean ...
    WindowSize

end

Filename = sprintf('WS%d_%d_P%d_%d',WindowSizeMin,WindowSizeMax,min(Prange),max(Prange));

save(Filename)

%% Find WindowSize + P combination at which certain error level is reached earliest

Error = 5; %percent
%Prange = fliplr(Prange);
OptimalP = zeros(1,length(WindowSizeMin:WindowSizeMax));
OptimSaccCount = zeros(1,length(WindowSizeMin:WindowSizeMax));

for WindowSize = WindowSizeMin:WindowSizeMax
    for Ptrial = length(Prange)-1:-1:1
        if SaccErrorPC(Ptrial,WindowSize) <= Error
            if SaccErrorPC(Ptrial+1,WindowSize) > Error
                OptimalP(WindowSize) = ...
                    mean([Prange(1,Ptrial) Prange(1,Ptrial+1)]);
                OptimSaccCount(WindowSize) = TrueSaccCount(Ptrial,WindowSize);
            end
        end
    end
end

figure, plot(WindowSizeMin:WindowSizeMax,OptimalP(1:WindowSizeMax));...
    ylabel('Optimal P (\sigma)'); xlabel('WindowSize (ms)')

figure, plot3(WindowSizeMin:WindowSizeMax,OptimalP(1:WindowSizeMax),OptimSaccCount);...
    ylabel('Optimal P (\sigma)'); xlabel('WindowSize (ms)'); zlabel('TrueSaccCount');

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
