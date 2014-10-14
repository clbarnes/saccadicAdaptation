Error = 5;

[Ptrialno,WindowSizeMax] = size(TrueSaccCount);
ErrorPCpointP = nan(1,WindowSizeMax);
ErrorPCpointTSC = nan(1,WindowSizeMax);

for WindowSize = 1:WindowSizeMax
    for Ptrial = 2:Ptrialno
        if SaccErrorPC(Ptrial,WindowSize) >= 5
            if SaccErrorPC(Ptrial-1,WindowSize) <=5
                ErrorPCpointP(:,WindowSize) = Prange(1,Ptrial-1);
                ErrorPCpointTSC(:,WindowSize) = TrueSaccCount(Ptrial-1,WindowSize);
            end
        end
    end
end

max(max(ErrorPCpointTSC))