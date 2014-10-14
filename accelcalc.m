function out = accelcalc(SpeedData,TrialTime)

in = SpeedData; t = TrialTime;
%%

%in = Msaccspeed; t = Msacctime;

s = size(in);
out = nan(s(1,1),s(1,2));

st = size(t);

accelt = zeros(s(1,1),s(1,2));


for j = 1:st(1,1)
    for i = 2:st(1,2)
        if t(j,i) ~= 0
            accelt(j,i) = mean([t(j,i) t(j,i-1)]);
        else
            accelt(j,i) = nan;
        end
    end
end

for j = 1:s(1,1)
    for i = 3:s(1,2)
        
        if in(j,i) == 0
            eyeaccel = 0;
        else
            eyeaccel = in(j,i) - in(j,i-1);
        end
        
        if isnan(accelt(j,i)) == 0
            out(j,i) = eyeaccel/(accelt(j,i)-accelt(j,i-1));
        else
            out(j,i) = nan;
        end
        
    end
end

%Msaccaccel = out;
%%

end
