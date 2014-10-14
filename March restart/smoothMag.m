function out = smoothMag(Data,WindowSize)

out = Data;

[trialno binno] = size(out);

for trial = 1:trialno
    for bin = WindowSize:binno
        out(trial,bin) = nanmean(Data(trial,(bin-(WindowSize-1)):bin));
    end
end

end