function out = nanstdall(data)

[x,y,z] = size(data);

dataflat = reshape(data,1,x*y*z,1);

out = nanstd(dataflat);

end

