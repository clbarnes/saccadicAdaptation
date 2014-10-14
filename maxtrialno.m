function out = maxtrialno(maxtime,calibfreq,blocksize)

maxtimesecs = maxtime*60;

trialno = blocksize*maxtime; timesecs = maxtimesecs+1;

while timesecs > maxtimesecs
    
    trialno = trialno - blocksize;

    timesecs = exptimesecs(trialno,calibfreq);
    
end

out = trialno;