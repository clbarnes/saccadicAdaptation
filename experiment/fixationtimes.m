TrialBlockNo = 9; ControlBlockNo = 2; TestBlockNo = TrialBlockNo - ControlBlockNo;

%FollowingOrPreceding = 'following';
FollowingOrPreceding = 'preceding';

%% generate XTicks

BlockIDs = {};

for TrialBlock = 1:ControlBlockNo
    ThisBlockID = sprintf('C%d',TrialBlock);
    BlockIDs = horzcat(BlockIDs, ThisBlockID);
end

for TrialBlock = 1:TestBlockNo
    ThisBlockID = sprintf('T%d',TrialBlock+ControlBlockNo);
    BlockIDs = horzcat(BlockIDs, ThisBlockID);
end

%% for preceding-offset saccades

if strcmp(FollowingOrPreceding,'preceding') == 1
    
    NPOmeans = nan(TrialBlockNo,1);
    POmeans = nan(TrialBlockNo,1);
    NPOstds = nan(TrialBlockNo,1);
    POstds = nan(TrialBlockNo,1);
    
    for i = 1:TrialBlockNo
        NPOmeans(i) = nanmean(fixationsNPO(i,:));
        NPOstds(i) = nanstd(fixationsNPO(i,:));
    end
    
    for i = 3:TrialBlockNo
        POmeans(i) = nanmean(fixationsPO(i,:));
        POstds(i) = nanstd(fixationsPO(i,:));
    end
    
    errorbar(NPOmeans,NPOstds,'color','blue'); hold all;
    errorbar(POmeans,POstds,'color','red');
    
    ylabel('Mean Fixation Time (s)');
    xlabel('Trial Block');
    set(gca,'XTick',1:TrialBlockNo); xlim([0 TrialBlockNo+1]);
    set(gca,'XTickLabel',BlockIDs);
    legend('Mean fixation time not preceding display offset','Mean fixation time preceding display offset')
    title('Change in mean fixation time over a number of trial blocks');
    
    hold off;
    
end

%% for following-offset saccades

if strcmp(FollowingOrPreceding,'following') == 1
    
    NFOmeans = nan(TrialBlockNo,1);
    FOmeans = nan(TrialBlockNo,1);
    NFOstds = nan(TrialBlockNo,1);
    FOstds = nan(TrialBlockNo,1);
    
    for i = 1:TrialBlockNo
        NFOmeans(i) = nanmean(fixationsNFO(i,:));
        NFOstds(i) = nanstd(fixationsNFO(i,:));
    end
    
    for i = 3:TrialBlockNo
        FOmeans(i) = nanmean(fixationsFO(i,:));
        FOstds(i) = nanstd(fixationsFO(i,:));
    end
    
    errorbar(NFOmeans,NFOstds,'color','blue'); hold all;
    errorbar(FOmeans,FOstds,'color','red');
    
    ylabel('Mean Fixation Time (s)');
    xlabel('Trial Block');
    set(gca,'XTick',1:TrialBlockNo); xlim([0 TrialBlockNo+1]);
    set(gca,'XTickLabel',BlockIDs);
    legend('Mean fixation time not following display offset','Mean fixation time following display offset')
    title('Change in mean fixation time over a number of trial blocks');
    
    hold off;
    
end