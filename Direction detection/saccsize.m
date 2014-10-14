function SaccSize = saccsize(SaccStart,SaccEnd,TrialBlockSize)

[trialno,saccno,dno] = size(SaccEnd);
TrialBlockNo = trialno/TrialBlockSize;

if iswhole(TrialBlockNo) == 0
    error('Need whole number of trial blocks');
end

SaccSize = nan(TrialBlockNo,saccno*TrialBlockSize,3);

for TrialBlock = 1:TrialBlockNo
    SaccCounter = 0;
    for trial = (TrialBlock-1)*TrialBlockSize+1:TrialBlock*TrialBlockSize
        for sacc = 1:saccno
            if isnan(SaccEnd(trial,sacc,1)) == 1
                break
            end
            
            SaccCounter = SaccCounter + 1;
            
            for d = 1:dno
                SaccSize(TrialBlock,SaccCounter,d) = abs(SaccEnd(trial,sacc,d) - SaccStart(trial,sacc,d));
            end
            
            SaccSize(TrialBlock,SaccCounter,3) = pythag(SaccSize(TrialBlock,SaccCounter,1),SaccSize(TrialBlock,SaccCounter,2));
            
        end
    end
end