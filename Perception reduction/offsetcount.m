function PerceptionRate = offsetcount(D,Perceived)

DO = D.FrameDataExp.DisplayOffset;

count = 0;

for i = 1:200
found = find(DO(i,:,1),1);
if found > 0
count = count + 1;
end

PerceptionRate = (Perceived/count);

fprintf('Perception rate: %d\n',PerceptionRate*100);

end