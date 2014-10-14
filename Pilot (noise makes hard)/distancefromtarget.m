[trialno,binno,dno] = size(D.FrameDataExp.EyePosition);

EyePosition = D.FrameDataExp.EyePosition;

for trial = 1:trialno
    for bin = 1:binno
    EyePosition(trial,bin,3) = ...
            pythag(EyePosition(trial,bin,1)-D.FrameDataExp.TargetPosition(trial,bin,1), ...
            EyePosition(trial,bin,2)-D.FrameDataExp.TargetPosition(trial,bin,2));
    end
end

for i = 1:50
    
    trial = randi(trialno,1);
    figure, plot(EyePosition(trial,:,3)); hold on;
    plot(abs(diff(D.FrameDataExp.TargetPosition(trial,:,1)))*20,'color','red');
    
    ylim([0 25]); xlim([0 4000]);
    
    if D.TargetHit(trial) == 1
        title('Detected');
    elseif TargetHitC(trial) == 1
        title('Detected - C');
    else
        title('Undetected');
    end
    
    hold off;
    
end