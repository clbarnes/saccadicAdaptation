[trialno, binno, dno] = size(D.FrameDataExp.EyePosition);

for trial = 1:trialno
    
    if TargetHitC(trial) == 0
        figure, plot(D.FrameDataExp.EyePosition(trial,:,1)-D.FrameDataExp.TargetPosition(trial,:,1));
        hold on;
        plot(D.FrameDataExp.EyePosition(trial,:,2)-D.FrameDataExp.TargetPosition(trial,:,2),'color','red'); hold off;
    end
    
end