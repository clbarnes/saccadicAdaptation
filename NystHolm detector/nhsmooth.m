[trialno,binno,dno] = size(D.FrameDataExp.EyePosition);
%trialno = 5; binno = 4001; dno = 3;
EyePosition = D.FrameDataExp.EyePosition;
TrialTime = D.FrameDataExp.TrialTime;
EyePositionS = D.FrameDataExp.EyePosition;
EyeSpeed = zeros(trialno,binno,dno);
EyeAccel = zeros(trialno,binno,dno);

MinSaccLength = 12; SGolayOrder = 2; SGolayWindowSize = MinSaccLength*2+1;
[b,g] = sgolay(SGolayOrder,SGolayWindowSize);

HalfWin  = ((SGolayWindowSize+1)/2) -1;

tic
for trial = 1:trialno
    
            %progress
        clc;
        fprintf('Savitzky-Golay filtering: In Process\n\n')
        
        fprintf('    Trial %d of %d\n',trial,trialno);
        
        elapsed = toc;
        completed = trial/trialno;
        fprintf('    %d%% complete\n\n',floor(completed*100));
        
        fprintf('    %d minutes elapsed\n',floor(elapsed/60));
        fprintf('    Less than %d minutes remaining\n',ceil((elapsed/completed-elapsed)/60));
        
        fprintf('Saccade Detection: Not Yet Started\n');
        fprintf('Direction Detection: Not Yet Started\n');
    
    for bin = 20:binno-(SGolayWindowSize+1)/2
        
        if D.FrameDataExp.BlinkEvent(trial,bin+HalfWin) == 1 ||...
                D.FrameDataExp.BlinkEvent(trial,bin-HalfWin) == 1
            %in case of blink, nan all the things
            EyePositionS(trial,bin,1:2) = nan(1,1,2);
            EyeSpeed(trial,bin,1:3) = nan(1,1,3);
            EyeAccel(trial,bin,1:3) = nan(1,1,3);
            continue
        end                     
        
        if D.FrameDataExp.TrialTime(trial,bin+HalfWin) == 0
            continue
        end
        
        %smoothing
        EyePositionS(trial,bin,1) = dot(g(:,1), EyePosition(trial,bin - HalfWin: bin + HalfWin,1));
        EyePositionS(trial,bin,2) = dot(g(:,1), EyePosition(trial,bin - HalfWin: bin + HalfWin,2));
        
        %speed
        EyeSpeed(trial,bin,1) = dot(g(:,2), EyePosition(trial,bin - HalfWin: bin + HalfWin,1))/0.001;
        EyeSpeed(trial,bin,2) = dot(g(:,2), EyePosition(trial,bin - HalfWin: bin + HalfWin,2))/0.001;
        EyeSpeed(trial,bin,3) = pythag(EyeSpeed(trial,bin,1),EyeSpeed(trial,bin,2));
        
        %acceleration
        EyeAccel(trial,bin,1) = dot(g(:,3), EyePosition(trial,bin - HalfWin: bin + HalfWin,1))/0.001^2;
        EyeAccel(trial,bin,2) = dot(g(:,3), EyePosition(trial,bin - HalfWin: bin + HalfWin,2))/0.001^2;
        EyeAccel(trial,bin,3) = pythag(EyeAccel(trial,bin,1),EyeAccel(trial,bin,2));
        
    end
    
end

for trial = 1:trialno
    for bin = 1:binno
        if TrialTime(trial,bin) == 0
            TrialTime(trial,bin:bin) = nan;
            EyePositionS(trial,bin,:) = nan(1,1,3);
            EyeSpeed(trial,bin,:) = nan(1,1,3);
            EyeAccel(trial,bin,:) = nan(1,1,3);
        end
    end
end

clc; fprintf('Complete\n');

clear HalfWin MinSaccLength SGolayOrder SGolayWindowSize
