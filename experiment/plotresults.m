function [means,stds] = plotresults(TestQuadrant,varargin)

% Input data structure.QuadrantsPC for each subject, returns graph and matrix of means
% + stds.

ControlBlockNo = 2;

subjectno = nargin-1; QuadrantNo = length(TestQuadrant);
[TrialBlockNo,a] = size(varargin{1});

TestBlockNo = TrialBlockNo - ControlBlockNo;

PCinTestQuad = zeros(subjectno,TrialBlockNo);

for subject = 1:subjectno
    %dataset = varargin(subject);
    eval(['QuadPC_' num2str(subject) ' =  varargin{subject};']);
    for TrialBlock = 1:TrialBlockNo
        for i = 1:QuadrantNo   
            eval(['PCinTestQuad(subject,TrialBlock) = PCinTestQuad(subject,TrialBlock)' ...
                '+ QuadPC_' num2str(subject) '(TrialBlock,TestQuadrant(i));']);
        end
    end
end

BlockIDs = {};

for TrialBlock = 1:ControlBlockNo
    ThisBlockID = sprintf('C%d',TrialBlock);
    BlockIDs = horzcat(BlockIDs, ThisBlockID);
end

for TrialBlock = 1:TestBlockNo
    ThisBlockID = sprintf('T%d',TrialBlock+ControlBlockNo);
    BlockIDs = horzcat(BlockIDs, ThisBlockID);
end

means = mean(PCinTestQuad); stds = std(PCinTestQuad);

errorbar(1:TrialBlockNo,means,stds,'color','black');
ylabel('Proportion of saccades made towards right (penalised) hemifield (%)');
xlabel('Trial Block');
ylim([40 60]); xlim([0 19]);
set(gca,'XTick',1:TrialBlockNo);
set(gca,'XTickLabel',BlockIDs);

hold all;
regression = [1:18].*(-0.01591)+50.14;
handle2 = plot(1:18,regression,'color','black','linestyle',':');
set(handle2,'linewidth',2.5);
legend('\mu across subjects; \sigma error bars','Least-squares linear regression')
hold off

%title('The change in saccade direction distribution across all trials');

end