% use this for counting peaks

%% Extract variables
tic
EyePosition = D.FrameDataExp.EyePosition; [trialno, binno, dno] = size(EyePosition);
EyePosition = dispcalc(EyePosition);
BlinkEvent = D.FrameDataExp.BlinkEvent; 
TrialTime = D.FrameDataExp.TrialTime;
GazeStable = D.FrameDataExp.GazeStable;
SaccadeEvent = D.FrameDataExp.SaccadeEvent;

%% Define variables
WindowSize = 5;
BlinkWindow = 30;

%% nan during Blinks, after trial end

clc; fprintf('Clearing Blinks\n');

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

clc; fprintf('Calculating speed\n');

EyeSpeedRaw = speedcalc_2(EyePosition,TrialTime);
EyeSpeed = smoothC(EyeSpeedRaw,WindowSize);
    EyeSpeed(:,:,3) = abs(EyeSpeed(:,:,3));

%% Calculate acceleration (raw and smooth)

% EyeAccelRaw = speedcalc_2(EyeSpeed,TrialTime);
% EyeAccel = smoothC(EyeAccelRaw,WindowSize);

%% Count peaks
SpeedThresEnd = dist2deg(30); TopSpeed = 420;

Maxi = length(linspace(1,ceil(dist2deg(TopSpeed)),100));

[trialno, binno, dno] = size(EyeSpeed);

mismatch = zeros(1,Maxi);
peakcount = zeros(1,Maxi);
SpeedThresholds = linspace(1,ceil(dist2deg(TopSpeed)),100);
i = 0;

SpeedThresholds = [];

starttime = toc;
tic

for SpeedThresStart = linspace(1,ceil(dist2deg(TopSpeed)),100)
    
    i = i+1; upcount = 0; downcount = 0;
       
    for trial = 1:trialno
        
        clc;
        fprintf('Threshold %d of %d\n',i,Maxi);
        fprintf('Trial %d of %d\n',trial,trialno);
        fprintf('    %d minutes elapsed\n',floor((starttime+toc)/60));
        fprintf('    %d minutes remaining\n',ceil((toc/(i/100)-toc)/60));
        
        peakfound = 0; maxspeed = deg2dist(SpeedThresStart);
        
        for bin = 2:binno
            if EyeSpeed(trial, bin, 3) > deg2dist(SpeedThresStart)
                if EyeSpeed(trial, bin-1, 3) < deg2dist(SpeedThresStart)
                    upcount = upcount + 1;
                end
            end
            
            if peakfound == 0;
                if EyeSpeed(trial, bin, 3) > deg2dist(SpeedThresStart)
                    if maxspeed < EyeSpeed(trial,bin,3)
                        maxspeed = EyeSpeed(trial,bin,3);
                    end
                    if maxspeed > EyeSpeed(trial,bin,3);
                        peakcount(i) = peakcount(i) + 1;
                        peakfound = 1;
                        maxspeed = deg2dist(SpeedThresStart);
                    end
                end
            end
            
            if EyeSpeed(trial, bin,3) < deg2dist(SpeedThresStart)
                if EyeSpeed(trial, bin-1,3) > deg2dist(SpeedThresStart)
                    downcount = downcount + 1;
                    peakfound = 0;
                end
            end
            
            mismatch(i) = upcount - downcount;
            
        end
    end
end

%% Graph

figure,plot(SpeedThresholds, peakcount,'color','black')
xlabel('Peak detection threshold ( ^{\circ}s^-1 )')
ylabel('Number of peaks detected')
            

%% Cleanup

clear trial trialno bin binno dno
