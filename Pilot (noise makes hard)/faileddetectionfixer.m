%function out = faileddetectionfixer(D)

D = input('Which Data Set? \n');

[trialno, binno, dno] = size(D.FrameDataExp.EyePosition);
TargetHitC = zeros(size(D.TargetHit));

LastFixation = nan(1,binno,4);

for trial = 1:trialno
    
    LastBin = binno-1 - find(fliplr(D.FrameDataExp.SaccadeEndPosition(trial,:,1)),1);
    WhileCount = 0;
    
    while D.FrameDataExp.GazeStable(trial,LastBin-WhileCount) == 1
        WhileCount = WhileCount + 1;
        LastFixation(trial,WhileCount,1:3) = ...
            D.FrameDataExp.EyePosition(trial,LastBin-WhileCount,:);
        LastFixation(trial,WhileCount,3) = ...
            pythag(LastFixation(trial,WhileCount,1)-D.FrameDataExp.TargetPosition(trial,LastBin-WhileCount,1), ...
            LastFixation(trial,WhileCount,2)-D.FrameDataExp.TargetPosition(trial,LastBin-WhileCount,2));
        
        LastFixation(trial,WhileCount,4) = ... %compare w/ D.TargetPosition
            pythag(LastFixation(trial,WhileCount,1)-D.TargetPosition(trial,1), ...
            LastFixation(trial,WhileCount,2)-D.TargetPosition(trial,2));
        
    end
    
%     LastFixation(trial,:,1) = fliplr(LastFixation(1,:,1));
%     LastFixation(trial,:,2) = fliplr(LastFixation(1,:,2));
    
    if D.TargetHit(trial,1) == 0
        
        if sum(D.FrameDataExp.GazeStable(trial,end-299:end)) == 300
        %if sum(D.FrameDataExp.SaccadeEvent(trial,end-299:end)) == 0
            TargetHitC(trial,1) = 1;            
        end
        
    end
    
end

fprintf('\nExtra detections: %d\n',sum(TargetHitC));

clear trialno binno dno trial WhileCount LastBin