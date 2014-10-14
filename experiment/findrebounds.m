SaccadeEvent = subject4.D.FrameDataExp.SaccadeEvent;

MinGap = 40;

[trialno,binno] = size(SaccadeEvent);

reboundcount = 0;

for trial = 1:trialno
    reboundbin = 0;
    for bin = MinGap:binno
        if SaccadeEvent(trial,bin) == 1 && SaccadeEvent(trial,bin-(MinGap-1)) == 1 &&...
                sum(SaccadeEvent(trial,bin-(MinGap-1):bin)) ~= MinGap
            if reboundbin == bin-1
                reboundbin = bin;
                continue
            else
            reboundcount = reboundcount + 1;
            reboundbin = bin;
            end
        end
    end
end

PCrebounds = reboundcount/sum(subject4.SaccCount)*100;

fprintf('\n')