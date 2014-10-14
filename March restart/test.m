[ATtrialno, WindowSizeMax] = size(TrueSaccCount);
SaccErrorPC = nan(ATtrialno,WindowSizeMax);

for ATtrial = 1:ATtrialno
    for WindowSize = 1:WindowSizeMax
        SaccErrorPC(ATtrial,WindowSize) = (BadSaccCount(ATtrial,WindowSize)*100) /...
            (BadSaccCount(ATtrial,WindowSize) + TrueSaccCount(ATtrial,WindowSize));
    end
end