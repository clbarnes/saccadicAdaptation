function HitTime = cleanhittime(D)

HitTime = D.HitTime;

for trial = 1:length(HitTime)
    if HitTime(trial) > D.TrialDuration(trial)
        HitTime(trial) = nan;
    end
end

end