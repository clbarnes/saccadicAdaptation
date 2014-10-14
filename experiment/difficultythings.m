%% concatenate

%diffstats = [diffstats_1 diffstats_2 diffstats_4 diffstats_5];

column = [1 6 11 16];

SaccadeCount = [];

for i = 1:4
    SaccadeCount = [SaccadeCount diffstats(:,column(i)+3)];
end

[h,p] = ranksum(straighten(SaccadeCount(1:2,:)),straighten(SaccadeCount(3:4,:)));

meanC = mean2(SaccadeCount(1:2,:)); stdC = std2(SaccadeCount(1:2,:));
meanT = mean2(SaccadeCount(3:4,:)); stdT = std2(SaccadeCount(3:4,:));