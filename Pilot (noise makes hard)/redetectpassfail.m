D = input('Which Data Set? \n');

[trialno, binno, dno] = size(D.FrameDataExp.EyePosition);
TargetHitC = D.TargetHit;
HitTimeC = D.HitTime;

for trial = 1:trialno
    if D.TargetHit(trial) == 1
        
        HitTimeC(trial) = ceil(HitTimeC(trial)*1000-10); %turn HitTime into bin ID
        
        while D.FrameDataExp.GazeStable(trial,HitTimeC(trial)) == 1
            HitTimeC(trial) = HitTimeC(trial) - 1;
        end
        
        HitTimeC(trial) = HitTimeC(trial)/1000; %back into time
    end
    
    if D.TargetHit(trial) == 0 && sum(D.FrameDataExp.GazeStable(trial,end-299:end)-1) == 0
        
            %if sum(D.FrameDataExp.SaccadeEvent(trial,end-299:end)) == 0
            TargetHitC(trial) = 1;
            
            HitTimeC(trial) = ceil(binno-10); %turn HitTime into bin ID
            
            while D.FrameDataExp.GazeStable(trial,HitTimeC(trial)) == 1
                HitTimeC(trial) = HitTimeC(trial) - 1;
            end
            
            HitTimeC(trial) = HitTimeC(trial)/1000; %back into time
    end
end

%difficulty_manual;