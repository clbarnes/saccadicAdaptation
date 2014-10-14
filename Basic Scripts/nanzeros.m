function out = nanzeros(in)

[ymax,xmax,zmax] = size(in);

out = in;

for y = 1:ymax
    for x = 1:xmax
        for z = 1:zmax
            if out(y,x,z) == 0
                out(y,x,z) = nan;
            end
        end
    end
end
end