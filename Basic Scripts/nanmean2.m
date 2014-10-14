function out = nanmean2(in)

[x y] = size(in);

out = nanmean(reshape(in,1,x*y));

end