%use this for finding optimal P + WS

StableAccelerationStdev = 510;
StableAccelerationMean = 670;
StableSpeedStdev = 2.54;
StableSpeedMean = 3.38;

[trialno,binno,dno] = size(EyePosition);
SaccadeEventC = zeros(trialno,binno);
SaccadeCount = nan(size(0:0.1:10));
i = 0;

SpeedOffThresh = 15;
    Pmin = (SpeedOffThresh-StableSpeedMean)/StableSpeedStdev;
Prange = [150:-1:ceil(Pmin)];

for P = Prange
    
    SpeedThresh = StableSpeedMean + StableSpeedStdev * P;
    AccelThresh = 0; %StableAccelerationMean + StableAccelerationStdev * P;
    i = i + 1;
    SaccadeCount(i) = 0;
    
    for trial = 1:trialno
        for bin = 2:binno
            if (abs(EyeSpeed(trial,bin,3))-SpeedThresh)...
                    *(abs(EyeSpeed(trial,bin-1,3))-SpeedThresh) <= 0;
                %if abs(EyeAccel(trial,bin,3)) >= AccelThresh
                    %if GazeStable(trial,bin) ~= 1
                    SaccadeEventC(trial,bin) = 1;
                    %end
                %end
            end
            
            if SaccadeEventC(trial,bin-1) == 1
                if abs(EyeSpeed(trial,bin,3)) > SpeedOffThresh;
                %if GazeStable(trial,bin) ~= 1
                    SaccadeEventC(trial,bin) = 1;
                %end
                end
            end
            
        end
    end
    
%         for trial = 1:trialno
%             for bin = 2:binno
%                 if SaccadeEventC(trial,bin) == 1
%                     if SaccadeEventC(trial,bin-1) == 0
%                         SaccadeCount(i) = SaccadeCount(i)+1;
%                     end
%                 end
%             end
%         end
    
    for trial = 1:trialno
        SaccStart = nan;
        SaccEnd = nan;
        
        for bin = 2:binno
            if SaccadeEventC(trial, bin) == 1
                if SaccadeEventC(trial,bin-1) == 0
                    SaccStart = TrialTime(trial,bin);
                end
            end
            if SaccadeEventC(trial,bin) == 0
                if SaccadeEventC(trial,bin-1) == 1
                    if isnan(SaccStart) == 0
                        SaccEnd = TrialTime(trial,bin);
                        SaccadeCount(i) = SaccadeCount(i)+1;
                        
                        SaccLength(i,SaccadeCount(i)) = SaccEnd - SaccStart;
                    end
                end
            end
            
        end
    end   
end

clc;
fprintf('Window Size %d of %d\n',WindowSize,WindowSizeMax);
elapsed = floor(toc/60);
fprintf('%d minutes elapsed\n',elapsed);
complete = WindowSize/(WindowSizeMax+1);
fprintf('%f%% complete\n',complete*100);
fprintf('Estimated %d minutes remaining\n',ceil((toc/complete)/60-elapsed));

%% Cleanup
clear AccelThresh P SpeedThresh StableAccelerationStdev ...
    StableSpeedMean StableSpeedStdev bin binno dno i trial trialno