function out = dispcalc(EyePosition)

[trialno,binno,dno] = size(EyePosition);
out = EyePosition;

for trial = 1:trialno    
    for bin = 2:binno    
        out(trial,bin,3) = ...
            pythag(EyePosition(trial,bin,1),EyePosition(trial,bin,2));
    end
end

end