for i = 1:5
    if i == 3
        continue
    end
   
    %% load data
    eval(['load(''Subject_' num2str(i) '/subject' num2str(i) '.mat'')']);
    
    %% extract variables
    eval(['SpeedThresPeakCB_' num2str(i) ' = subject' num2str(i) '.SpeedThresPeakCB;'...
        'SpeedThresOnCB_' num2str(i) ' = subject' num2str(i) '.SpeedThresOnCB;'...
        'SpeedThresOff_' num2str(i) ' = subject' num2str(i) '.SpeedThresOff;']);
    %% clear data
    eval(['clear subject' num2str(i)]);
end

%% Concatenate

SpeedThresOn = [SpeedThresOnCB_1(:,2) SpeedThresOnCB_2(:,2) SpeedThresOnCB_4(:,2) SpeedThresOnCB_5(:,2)];

SpeedThresPeak = [SpeedThresPeakCB_1(:,2) SpeedThresPeakCB_2(:,2) SpeedThresPeakCB_4(:,2) SpeedThresPeakCB_5(:,2)];

SpeedThresOff = [SpeedThresOff_1; SpeedThresOff_2; SpeedThresOff_4; SpeedThresOff_5];

%% fix what went horribly wrong

SpeedThresOffe = SpeedThresOff;

for i = 1:3600
    for j = 1:20
        if SpeedThresOff(i,j) >= 100
            SpeedThresOffe(i,j) = nan;
        end
    end
end