function out = nanstd2(in)

[x y] = size(in);

out = nanstd(reshape(in,1,x*y));

end
