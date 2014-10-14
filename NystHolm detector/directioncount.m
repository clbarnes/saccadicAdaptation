function NE_SE_SW_NW = directioncount(SaccDirection)

NEcount = 0;
SEcount = 0;
SWcount = 0;
NWcount = 0;

[trialno,MaxSaccCount] = size(SaccDirection);

for trial = 1:trialno
    for Sacc = 1:MaxSaccCount
        
        if 0 <= SaccDirection(trial,Sacc) &&...
                SaccDirection(trial,Sacc) < 90
            NEcount = NEcount + 1;
        end
        if 90 <= SaccDirection(trial,Sacc) &&...
                SaccDirection(trial,Sacc) < 180
            SEcount = SEcount + 1;
        end
        if 180 <= SaccDirection(trial,Sacc) &&...
                SaccDirection(trial,Sacc) < 270
            SWcount = SWcount + 1;
        end
        if 270 <= SaccDirection(trial,Sacc) &&...
                SaccDirection(trial,Sacc) < 360
            NWcount = NWcount + 1;
        end
        
    end
end

NE_SE_SW_NW = [NEcount SEcount SWcount NWcount];

end