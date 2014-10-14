function out = exptime(trialno,calibfreq)

TrialTime = 4; TrialDelay = 0.8; calibtime = 60;

timeseconds = trialno*(TrialTime+TrialDelay) + ceil(trialno/calibfreq)*calibtime;

out = ceil(timeseconds/60);

end