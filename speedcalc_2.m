function EyeSpeedRaw = speedcalc_2(EyePosition,TrialTime)

[trialno,binno,dno] = size(EyePosition);
EyeSpeedRaw = nan(trialno,binno,3);

for trial = 1:trialno    
    for bin = 2:binno
        for d = 1:2
            EyeSpeedRaw(trial,bin,d) = ...
                ( EyePosition(trial,bin,d)-EyePosition(trial,bin-1,d) ) / ... 
                ( TrialTime(trial,bin) - TrialTime(trial,bin-1) );
        end
        
        EyeSpeedRaw(trial,bin,3) = ...
            pythag(EyeSpeedRaw(trial,bin,1),EyeSpeedRaw(trial,bin,2));
    end
end

end