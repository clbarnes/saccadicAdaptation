function out = denan(in)

% Removes nans from a vector.

[x,y,z] = size(in);

if (x + y > 2) && (x + z > 2) && (y + z > 2)
    error('Not a vector'); 
end

count = 0;

for datum = 1:length(in)
    if isnan(in(datum)) == 0
        count = count +1;
    end
end

out = nan(1,count);

count = 0;

for datum = 1:length(in)
    if isnan(in(datum)) == 0
        count = count +1;
        out(count) = in(datum);
    end
end

end