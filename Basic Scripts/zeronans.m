function out = zeronans(in)

[ymax,xmax,zmax] = size(in);

out = in;

for y = 1:ymax
    for x = 1:xmax
        for z = 1:zmax
            if isnan(out(y,x,z)) == 1
                out(y,x,z) = 0;
            end
        end
    end
end
end
                