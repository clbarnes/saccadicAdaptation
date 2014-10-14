function [FixationTime,FixationTimePO,FixationTimeNPO] = fixationsplitPO(D,TrialBlockSize,SaccadeEvent)

%Finds vector of mean fixation times

% SaccadeEvent = D.FrameDataExp.SaccadeEvent; %might change this
% [trialno,binno] = size(D.FrameDataExp.SaccadeEvent);

%SaccadeEvent = SaccadeEventNH;

clc; fprintf('Initialising...\n');

[trialno,binno] = size(SaccadeEvent);

TrialBlockNo = trialno/TrialBlockSize;

if iswhole(TrialBlockNo) == 0
    error('Not whole number of trials');
end

for TrialBlock = 1:TrialBlockNo
    eval(['FixationTime_' num2str(TrialBlock) ' = [];']);
    %% separate fixations just after a display offset
%     eval(['FixationTimeFO_' num2str(TrialBlock) ' = [];']);
%     eval(['FixationTimeNFO_' num2str(TrialBlock) ' = [];']);
    %% separate fixations just before a display offset
     eval(['FixationTimePO_' num2str(TrialBlock) ' = [];']);
     eval(['FixationTimeNPO_' num2str(TrialBlock) ' = [];']);
end

tic

for TrialBlock = 1:TrialBlockNo
        trialcount = 0;
    
    for trial = (TrialBlock-1)*TrialBlockSize+1:TrialBlock*TrialBlockSize
        trialcount = trialcount + 1;
        clc;
        fprintf('Finding Fixations\n');
        fprintf('    Trial Block %d of %d\n',TrialBlock,TrialBlockNo)
        fprintf('        Trial %d of %d\n\n',trialcount,TrialBlockSize);
        fprintf('        %d%% complete\n',floor(trial/trialno*100));
        fprintf('        Less than %d minutes remaining \n\n',ceil((toc*(trialno/trial)-toc)/60));
        for bin = 2:binno
            if sum(SaccadeEvent(trial,1:bin)) >= 1 && sum(SaccadeEvent(trial,bin:end)) >= 1
                if SaccadeEvent(trial,bin-1) == 1 && SaccadeEvent(trial,bin) == 0
                    FixationStart = D.FrameDataExp.TrialTime(trial,bin); %#ok<NASGU>
                    
                    %find end of this fixation
                    
                    bin_FindEnd = bin;
                    while SaccadeEvent(trial,bin_FindEnd) == 0
                        FixationEnd = D.FrameDataExp.TrialTime(trial,bin_FindEnd); %#ok<NASGU>
                        bin_FindEnd = bin_FindEnd+1;
                    end
                   
                    
                    %% if separating fixations after display offset
%                     % find start of saccade preceding fixation
%                     
%                     bin_FindSaccStart = bin-1;
%                     while SaccadeEvent(trial,bin_FindSaccStart) == 1
%                         bin_FindSaccStart = bin_FindSaccStart - 1;
%                     end
%                     
%                     %check if preceding saccade caused display offset
%                     
%                     if sum(diff(D.FrameDataExp.DisplayOffset(trial,bin_FindSaccStart:bin))) ~= 0
%                         FixationFollowsOffset = 1;
%                     else
%                         FixationFollowsOffset = 0;
%                     end
                    
                    %% if separating fixations just before display offset
                    % find end of saccade after fixation
                    
                    bin_FindSaccEnd = bin_FindEnd+1;
                    while SaccadeEvent(trial,bin_FindSaccEnd) - SaccadeEvent(trial,bin_FindSaccEnd-1) <= 0
                        if bin_FindSaccEnd + 1 >= length(SaccadeEvent(trial,:))
                            break
                        else
                        bin_FindSaccEnd = bin_FindSaccEnd + 1;
                        end                        
                    end
                    
                    %check if following saccade caused display offset
                    
                    if sum(diff(D.FrameDataExp.DisplayOffset(trial,bin:bin_FindSaccEnd))) ~= 0
                        OffsetFollowsFixation = 1;
                    else
                        OffsetFollowsFixation = 0;
                    end                    
                                        
                    %% always
                    
                    eval(['FixationTime_' num2str(TrialBlock) ' =' ...
                        '[FixationTime_' num2str(TrialBlock) ', FixationEnd-FixationStart];']);
                    
                    %% if separating fixations after display offset
                    
%                     if FixationFollowsOffset == 1
%                         eval(['FixationTimeFO_' num2str(TrialBlock) ' =' ...
%                             '[FixationTimeFO_' num2str(TrialBlock) ', FixationEnd-FixationStart];']);
%                         
%                         eval(['FixationTimeNFO_' num2str(TrialBlock) ' =' ...
%                             '[FixationTimeNFO_' num2str(TrialBlock) ', nan];']);     
%                     else
%                         eval(['FixationTimeFO_' num2str(TrialBlock) ' =' ...
%                             '[FixationTimeFO_' num2str(TrialBlock) ', nan];']);
%                         
%                         eval(['FixationTimeNFO_' num2str(TrialBlock) ' =' ...
%                             '[FixationTimeNFO_' num2str(TrialBlock) ', FixationEnd-FixationStart];']);
%                     end
                    
                    %% if separating fixations just before display offset

                    if OffsetFollowsFixation == 1
                        eval(['FixationTimePO_' num2str(TrialBlock) ' =' ...
                            '[FixationTimePO_' num2str(TrialBlock) ', FixationEnd-FixationStart];']);
                        
                        eval(['FixationTimeNPO_' num2str(TrialBlock) ' =' ...
                            '[FixationTimeNPO_' num2str(TrialBlock) ', nan];']);     
                    else
                        eval(['FixationTimePO_' num2str(TrialBlock) ' =' ...
                            '[FixationTimePO_' num2str(TrialBlock) ', nan];']);
                        
                        eval(['FixationTimeNPO_' num2str(TrialBlock) ' =' ...
                            '[FixationTimeNPO_' num2str(TrialBlock) ', FixationEnd-FixationStart];']);
                    end
                    
                    
                end
            end
        end
    end
    
end

fprintf('Concatenating results... ');

FixationNumber = zeros(1,TrialBlockNo);

for TrialBlock = 1:TrialBlockNo
    eval(['FixationNumber = [FixationNumber length(FixationTime_' num2str(TrialBlock) ')];']);
end

FixationTime = nan(TrialBlockNo,max(FixationNumber));

%% if separating fixations after display offset
% FixationTimeFO = nan(TrialBlockNo,max(FixationNumber));
% FixationTimeNFO = nan(TrialBlockNo,max(FixationNumber));
% 
% for TrialBlock = 1:TrialBlockNo
%     eval(['FixationTime(TrialBlock,1:length(FixationTime_' num2str(TrialBlock) ')) = FixationTime_' num2str(TrialBlock) ';']);
%     
%     eval(['FixationTimeFO(TrialBlock,1:length(FixationTime_' num2str(TrialBlock) ')) = FixationTimeFO_' num2str(TrialBlock) ';']);
%     eval(['FixationTimeNFO(TrialBlock,1:length(FixationTime_' num2str(TrialBlock) ')) = FixationTimeNFO_' num2str(TrialBlock) ';']);
% end

%% if separating fixations just before display offset
FixationTimePO = nan(TrialBlockNo,max(FixationNumber));
FixationTimeNPO = nan(TrialBlockNo,max(FixationNumber));

for TrialBlock = 1:TrialBlockNo
    eval(['FixationTime(TrialBlock,1:length(FixationTime_' num2str(TrialBlock) ')) = FixationTime_' num2str(TrialBlock) ';']);
    
    eval(['FixationTimePO(TrialBlock,1:length(FixationTime_' num2str(TrialBlock) ')) = FixationTimePO_' num2str(TrialBlock) ';']);
    eval(['FixationTimeNPO(TrialBlock,1:length(FixationTime_' num2str(TrialBlock) ')) = FixationTimeNPO_' num2str(TrialBlock) ';']);
end

%% back to normal

%cumufreqcompare(FixationTime,2000);

fprintf('Complete.\n\n');

end