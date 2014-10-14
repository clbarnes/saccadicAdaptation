function [out,DoDisplayShift] = catchbadoffsets(D,SaccadeEvent)

[trialno,binno,dno] = size(D.FrameDataExp.DisplayOffset);

OffsetCount = 0;
BadOffsetCount = 0;

DoDisplayShift = zeros(trialno,binno);

for trial = 1:trialno
    for bin = 10:binno-1
        
        if D.FrameDataExp.TrialTime(trial,bin) == 0
            continue
        end
        
        if D.FrameDataExp.TargetPosition(trial,bin,1) ~= D.FrameDataExp.TargetPosition(trial,bin-1,1)
            OffsetCount = OffsetCount + 1;
            DoDisplayShift(trial,bin) = 1;
            
            if SaccadeEvent(trial,bin) == 0
                BadOffsetCount = BadOffsetCount + 1;
            end
               
        end
    end
end

out = BadOffsetCount/OffsetCount;

end
            