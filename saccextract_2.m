thresholdspeed = 40;
startbuffer = 20 + WindowSize;
finishbuffer = 50;

saccno = 0;

[y x z] = size(espeed);

%% Detect and extract saccades

for j = 1:y
    for i = (startbuffer + 1):(x-(finishbuffer+1))
        if espeed(j,i,3) >= thresholdspeed
            if espeed(j,i-1,3) < thresholdspeed
                start = i - startbuffer;
            end
            if espeed(j,i+1,3) < thresholdspeed
                finish = i + finishbuffer;
                saccno = saccno + 1;
                
                thissacc = epos(j,start-1:finish,:);
                
                saccades(saccno,1:length(thissacc),:) = thissacc;
                sacctime(saccno,1:length(thissacc)) = trialtime(j,start-1:finish);
                
                for k = 1:3
                disp(saccno,1,k) = mean(thissacc(1,(end-(WindowSize-1)):end,k));
                end
            end
        end
    end
end

%% Clear 0s

[y x z] = size(saccades);

for j = 1:y
    for i = 1:x
        for k = 1:z
            if saccades(j,i,k) == 0
                saccades(j,i,k) = nan;
            end
        end
        if sacctime(j,i) == 0
            sacctime(j,i) = nan;
        end
    end
end

%% Normalise for initial fixation

for j = 1:y
    for d = 1:z
    saccades(j,:,d) = saccades(j,:,d)-mean(saccades(j,1:WindowSize,d));
    end
    sacctime(j,:) = sacctime(j,:)-sacctime(j,WindowSize);
end

%% Cleanup
clear i j y x z thresholdspeed finishbuffer saccno d start finish