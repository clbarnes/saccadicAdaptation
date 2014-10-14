%function out = correctionsaccadefinder(D,SaccadeEvent,TrialBlockSize)

SaccadeEvent = SaccadeEventNH; TrialBlockSize = 50;
[trialno,binno,dno] = size(D.FrameDataExp.EyePosition);

TrialBlockNo = trialno/TrialBlockSize;

if iswhole(TrialBlockNo) == 0
    error('Not whole number of blocks');
end

BearingTol = 45;

%% set up 360x3 vector
% Angles = nan(1,360*3);
% 
% for revolution = 1:3
%     for degree = 1:360
%         Angles((revolution-1)*360+degree) = degree;
%     end
% end
%%

CorrectiveCount = zeros(TrialBlockNo,1);
OffsetCount = 0; %zeros(TrialBlockNo,1);

for TrialBlock = 1:TrialBlockNo
    for trial = (TrialBlock-1)*TrialBlockSize+1:TrialBlock*TrialBlockSize
        
        for bin = 2:binno
            
            if D.FrameDataExp.TrialTime(trial,bin) == 0
                break
            end
            
            if diff(D.FrameDataExp.DisplayOffset(trial,bin-1:bin,1)) ~= 0 ||...
                    diff(D.FrameDataExp.DisplayOffset(trial,bin-1:bin,2)) ~= 0
                
                OffsetCount = OffsetCount + 1;
                
                DisplayShift(OffsetCount,1:2) = [diff(D.FrameDataExp.DisplayOffset(trial,bin-1:bin,1)), ...
                    diff(D.FrameDataExp.DisplayOffset(trial,bin-1:bin,2))];
                
                OffsetBearing(OffsetCount) = findbearing(0,0,DisplayShift(1,1),DisplayShift(1,2));
                OffsetGain(OffsetCount) = pythag(DisplayShift(1,1),DisplayShift(1,2));
                
                testbin = bin;
                while SaccadeEvent(trial,testbin) <= SaccadeEvent(trial,testbin-1) && testbin < 4000
                    testbin = testbin + 1;
                end
                
                NextSaccade(OffsetCount,1,1:2) = D.FrameDataExp.EyePosition(trial,testbin,1:2);
                
                while SaccadeEvent(trial,testbin) >= SaccadeEvent(trial,testbin-1) && testbin < 4000
                    testbin = testbin + 1;
                end
                
                if testbin >= 4000
                    OffsetCount = OffsetCount - 1;
                    break
                end
                
                NextSaccade(OffsetCount,2,1:2) = D.FrameDataExp.EyePosition(trial,testbin,1:2);
                
                SaccadeShift(OffsetCount,1) = NextSaccade(OffsetCount,2,1)-NextSaccade(OffsetCount,1,1);
                SaccadeShift(OffsetCount,2) = NextSaccade(OffsetCount,2,2)-NextSaccade(OffsetCount,1,2);
                
                SaccadeBearing(OffsetCount) = findbearing(0,0,SaccadeShift(OffsetCount,1),SaccadeShift(OffsetCount,2));
                SaccadeGain(OffsetCount) = pythag(SaccadeShift(OffsetCount,1),SaccadeShift(OffsetCount,2));
                
                if SaccadeGain(OffsetCount) > 0.5*OffsetGain(OffsetCount) && SaccadeGain(OffsetCount) < 1.5*OffsetGain(OffsetCount)
                    if SaccadeBearing(OffsetCount) > anglefix(OffsetBearing(OffsetCount)-BearingTol) &&...
                            SaccadeBearing(OffsetCount) < anglefix(OffsetBearing(OffsetCount)+BearingTol)
                        CorrectiveCount(TrialBlock) = CorrectiveCount(TrialBlock) + 1;
                    end
                end
                
            end
        end
    end
end

%out = CorrectiveCount;
