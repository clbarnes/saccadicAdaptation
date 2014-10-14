function EyeAccelRaw = accelcalc_2(EyeSpeed,TrialTime)

EyeAccelRaw = EyeSpeed; [trialno, binno, dno] = size(EyeAccelRaw);
SpeedTime = TrialTime;

for trial = 1:trialno
    for bin = 2:binno
        SpeedTime(trial,bin) = mean(TrialTime(trial,bin-1:bin));
    end
end

for trial = 1:trialno
    for bin = 2:binno-1
        for d = 1:dno
            EyeAccelRaw(trial,bin,d) = ...
                ( EyeSpeed(trial,bin+1,d) - EyeSpeed(trial,bin,d) ) / ... 
                ( SpeedTime(trial,bin+1) - SpeedTime(trial,bin) );
        end
    end
end

end