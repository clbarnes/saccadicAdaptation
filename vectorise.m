function out = vectorise(X,Y)

s = size(X);
out = zeros(s(1,1),s(1,2));

for j = 1:s(1,1)
    for i = 1:s(1,2)
        out(j,i) = pythag(X(j,i),Y(j,i));
    end
end
end