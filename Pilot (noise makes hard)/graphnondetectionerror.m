[trialno, binno, dno] = size(D.FrameDataExp.EyePosition);
UndetectedCount = 0;
DetectedCount = 0;

for trial = 1:trialno
    if TargetHitC(trial) == 1 && D.TargetHit(trial) == 0 && UndetectedCount <= 5
        UndetectedCount = UndetectedCount + 1;
        figure, plot(fliplr(LastFixation(trial,1:500,3))); hold all;
        ylim([0 2]); title('Undetected');
        xlabel('Last 500 bins of trial'); ylabel('Distance from TargetPosition (cm)');
        hold off;
    end
    
    if D.TargetHit(trial) == 1 && DetectedCount <= 5
        DetectedCount = DetectedCount + 1;
        figure, plot(fliplr(LastFixation(trial,1:500,3))); hold all;
        ylim([0 2]); title('Detected');
        xlabel('Last 500 bins of trial'); ylabel('Distance from TargetPosition (cm)');
        hold off;
    end
    
end