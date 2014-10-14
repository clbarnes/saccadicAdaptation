function out = iswhole(in)

if abs(round(in)) - abs(in) == 0
    out = 1;
else
    out = 0;
end

end
