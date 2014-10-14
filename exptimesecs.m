function out = exptimesecs(trialno,calibfreq)

TrialTime = 4.1; TrialDelay = 1.4; calibtime = 30;

timeseconds = trialno*(TrialTime+TrialDelay) + ceil(trialno/calibfreq)*calibtime;

out = timeseconds;

end