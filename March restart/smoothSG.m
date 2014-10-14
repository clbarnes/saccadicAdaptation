function out = smoothSG(in)

[trialno, binno, dno] = size(in);

out = in;

for d = 1:dno
    for trial = 1:trialno
        out(trial,:,d) = sgolayfilt(in(trial,:,d),2,25);
    end
end