for trialblock = 1:18
    SSBDmean(trialblock) = dist2deg(nanmean(straighten(SSBD(trialblock,1:2,:))));
    SSBDstd(trialblock) = dist2deg(nanstd(straighten(SSBD(trialblock,1:2,:))));
end

TrialBlockNo = 18; ControlBlockNo = 2;
TestBlockNo = TrialBlockNo - ControlBlockNo;
BlockIDs = {};

for TrialBlock = 1:ControlBlockNo
    ThisBlockID = sprintf('C%d',TrialBlock);
    BlockIDs = horzcat(BlockIDs, ThisBlockID);
end

for TrialBlock = 1:TestBlockNo
    ThisBlockID = sprintf('T%d',TrialBlock+ControlBlockNo);
    BlockIDs = horzcat(BlockIDs, ThisBlockID);
end

%means = mean(PCinTestQuad); stds = std(PCinTestQuad);

%%

errorbar(1:TrialBlockNo,SSBDmean,SSBDstd,'color','black');
ylabel('Mean magnitude of saccades made towards right (penalised) hemifield (degrees)');
xlabel('Trial Block');
ylim([-2 12]);
xlim([0 19]);
set(gca,'XTick',1:TrialBlockNo);
set(gca,'XTickLabel',BlockIDs);
legend('\mu per trial block; \sigma error bars')
hold off