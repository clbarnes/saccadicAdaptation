%% Export data to Matlab

WindowSize = 9;

filename = input('Data file name: ', 's');
eval(['[E,R] = DATAFILE_Read(''' filename ''')'])

data = E.FrameDataExp.EyePosition;

%% Sanitise the data

trials = 0;

[y x z] = size(data);
epos = nan(1,x,2);

% get rid of blinked trials
for i = 1:y
    if sum(E.FrameDataExp.BlinkEvent(i,:)) == 0
        trials = trials + 1;
        epos(trials,:,:) = data(i,:,1:2);
        trialtime(trials,:) = E.FrameDataExp.TrialTime(i,:);
    end
end

clear data x y z i

[y x z] = size(epos);

% replace 0s with nans
for k = 1:z
    for j = 1:y
        for i = 1:x
            if epos(j,i,k) == 0
                epos(j,i,k) = nan;
            end
        end
    end
end

clear x y z k j i

%% Calculate displacement + speed

epos(:,:,3) = vectorise(epos(:,:,1),epos(:,:,2));

%saccspeed(:,:,1) = smooth(speedcalc(saccades(:,:,1),sacctime),WindowSize);
%saccspeed(:,:,2) = smooth(speedcalc(saccades(:,:,2),sacctime),WindowSize);
espeed(:,:,3) = smooth(speedcalc(epos(:,:,3),trialtime),WindowSize);

%% Extract saccades

saccextract_2;

%% Calculate speed and acceleration

saccspeed(:,:,1) = smooth(speedcalc(saccades(:,:,1),sacctime),WindowSize);
saccspeed(:,:,2) = smooth(speedcalc(saccades(:,:,2),sacctime),WindowSize);
saccspeed(:,:,3) = vectorise(saccspeed(:,:,1),saccspeed(:,:,2)); %abs or not?
 
saccaccel(:,:,1) = smooth(accelcalc(saccspeed(:,:,1),sacctime),WindowSize);
saccaccel(:,:,2) = smooth(accelcalc(saccspeed(:,:,2),sacctime),WindowSize);
saccaccel(:,:,3) = smooth(accelcalc(saccspeed(:,:,3),sacctime),WindowSize);
% Do I need to be smoothing these? Probably.

%% Clear unsmoothed section of data

saccades = saccades(:,WindowSize:end,:);
saccspeed = saccspeed(:,WindowSize:end,:);
saccaccel = saccaccel(:,WindowSize:end,:);

sacctime = sacctime(:,WindowSize:end);

%% Clean up

clear filename