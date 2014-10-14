[y x z] = size(Msaccaccel);

%% Find peak speed

peakaccel = zeros(y,1);
peakapos = zeros(y,1,z);

for j = 1:y
    for i = (floor(WindowSize/2)+1):x
        if Msaccevent(j,i) == 1
            if Msaccaccel(j,i,3) > peakaccel(j,1)
                peakaccel(j,1) = Msaccaccel(j,i,3);
                for k = 1:3
                    peakapos(j,1,k) = mean(Msaccades(j,(i - floor(WindowSize/2)):(i + ceil(WindowSize/2)),k));
                end
            end
        end
    end
end

%% Find amplitude

disp = vectorise(Msaccend(:,1,1),Msaccend(:,1,2));
%% Cleanup
clear s j