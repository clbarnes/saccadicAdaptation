function out = smoothC(Data,WindowSize)

out = Data;

[y x z] = size(out);

for k = 1:z
for j = 1:y
    for i = WindowSize:x
        out(j,i,k) = nanmean(Data(j,(i-(WindowSize-1)):i));
    end
end
end

end