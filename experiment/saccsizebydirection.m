function [raw,means,stds] = saccsizebydirection(SaccSize,SaccDirectionBlock)

[TrialBlockNo,saccno] = size(SaccDirectionBlock);

raw = nan(TrialBlockNo,4,saccno);
means = nan(TrialBlockNo,4);
stds = nan(TrialBlockNo,4);

for TrialBlock = 1:TrialBlockNo
    for sacc = 1:saccno
        if isnan(SaccDirectionBlock(TrialBlock,sacc)) == 1
            continue
        end
        
        if SaccDirectionBlock(TrialBlock,sacc) > 0 &&...
                SaccDirectionBlock(TrialBlock,sacc) < 90
            raw(TrialBlock,1,sacc) = SaccSize(TrialBlock,sacc);
        end
        
        if SaccDirectionBlock(TrialBlock,sacc) > 90 &&...
                SaccDirectionBlock(TrialBlock,sacc) < 180
            raw(TrialBlock,2,sacc) = SaccSize(TrialBlock,sacc);
        end
        
        if SaccDirectionBlock(TrialBlock,sacc) > 180 &&...
                SaccDirectionBlock(TrialBlock,sacc) < 270
            raw(TrialBlock,3,sacc) = SaccSize(TrialBlock,sacc);
        end
        
        if SaccDirectionBlock(TrialBlock,sacc) > 270 &&...
                SaccDirectionBlock(TrialBlock,sacc) < 360
            raw(TrialBlock,4,sacc) = SaccSize(TrialBlock,sacc);
        end
    end
end

for TrialBlock = 1:TrialBlockNo
    for quadrant = 1:4
        means(TrialBlock,quadrant) = nanmean(raw(TrialBlock,quadrant,:));
        stds(TrialBlock,quadrant) = nanstd(raw(TrialBlock,quadrant,:));
    end
end
    