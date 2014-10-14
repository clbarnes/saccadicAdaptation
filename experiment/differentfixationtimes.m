%% in total

difference = nan(16,2);

for i = 3:18
    [difference(i-2,1),difference(i-2,2)] = ranksum(denan(FixationTimeFO(i,:)),denan(FixationTimeNFO(i,:)));
end

differencetotal = nan(1,2);

[differencetotal(1),differencetotal(2)] = ranksum(denan(straighten((FixationTimeFO(3:18,:)))),denan(straighten(FixationTimeNFO(3:18,:))));

%% plot a graph
ControlBlockNo = 2; TrialBlockNo = 18; TestBlockNo = TrialBlockNo-ControlBlockNo;
BlockIDs = {};

for TrialBlock = 1:ControlBlockNo
    ThisBlockID = sprintf('C%d',TrialBlock);
    BlockIDs = horzcat(BlockIDs, ThisBlockID);
end

for TrialBlock = 1:TestBlockNo
    ThisBlockID = sprintf('T%d',TrialBlock+ControlBlockNo);
    BlockIDs = horzcat(BlockIDs, ThisBlockID);
end

meansNFO = nanmean(FixationTimeNFO');
stdsNFO = nanstd(FixationTimeNFO');
meansFO = [nan nan nanmean(FixationTimeFO(3:18,:)')];
stdsFO = [nan nan nanstd(FixationTimeFO(3:18,:)')];

plot(meansNFO*1000,'color','black','marker','x','markersize',10); hold all;
xlabel('Trial Block');
ylabel('Mean fixation time across all subjects (ms)');
set(gca,'XTick',1:TrialBlockNo);
set(gca,'XTickLabel',BlockIDs);
xlim([0 19]); ylim([0.15*1000 0.35*1000]);
plot(meansFO*1000,'color','black','linestyle',':','marker','o','markersize',5);
legend('Fixations not following a display offset','Fixations immediately following a display offset');
hold off;

%% early on

%separate into trials

% FixationTime_trial = FixationTime(3,:);
% FixationTimeFO_trial = FixationTimeFO(3,:);
% FixationTimeNFO_trial = FixationTimeNFO(3,:);
% 
% FixationTime_trials = nans(50,20);
% FixationTimeFO_trials = nans(50,20);
% FixationTimeNFO_trials = nans(50,20);
% 
% for i = 1:

