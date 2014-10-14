function out = speedcalc(PositionData,TrialTime)

in = PositionData; t = TrialTime;

s = size(in);
out = nan(s(1,1),s(1,2));

for j = 1:s(1,1)
    for i = 2:s(1,2)
        if in(j,i) == 0
            eyespeed = 0;
        else
            eyespeed = in(j,i) - in(j,i-1);
        end
        if t(j,i) ~= 0
            out(j,i) = eyespeed/(t(j,i)-t(j,i-1));
        else
            out(j,i) = 0;
        end
    end
end