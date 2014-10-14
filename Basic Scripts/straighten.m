function out = straighten(data)

[x,y,z] = size(data);

out = reshape(data,1,x*y*z,1);

end