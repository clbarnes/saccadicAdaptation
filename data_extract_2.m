%% Export data to Matlab

WindowSize = 9;
DThreshold = 1.15;

% filename = input('Data file name: ', 's');
% eval(['[D,R] = DATAFILE_Read(''' filename ''')'])

data = D.FrameDataExp.EyePosition;
SaccadeEvent = D.FrameDataExp.SaccadeEvent;

%% Sanitise the data

trials = 0;

[y x z] = size(data);
epos = nan(1,x,2);

% get rid of blinked trials
for i = 1:y
    if sum(D.FrameDataExp.BlinkEvent(i,:)) == 0
        trials = trials + 1;
        epos(trials,:,:) = data(i,:,1:2);
        esaccades(trials,:) = SaccadeEvent(i,:);
        trialtime(trials,:) = D.FrameDataExp.TrialTime(i,:);
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

%% Extract saccades

saccextractor;

%% Get rid of microsaccades

[y x z] = size(saccades);
sacc_no = 0;

for j = 1:y
    if pythag(saccend(j,1),saccend(j,2)) >= DThreshold
        sacc_no = sacc_no + 1;
        Msaccades(sacc_no,:,:) = saccades(j,:,:);
        Msacctime(sacc_no,:) = sacctime(j,:);
        Msaccevent(sacc_no,:) = saccevent(j,:);
        Msaccend(sacc_no,:,:) = saccend(j,:,:);
    end
end
        
% %% Calculate displacement + speed
% 
% epos(:,:,3) = vectorise(epos(:,:,1),epos(:,:,2));
% 
% %saccspeed(:,:,1) = smooth(speedcalc(saccades(:,:,1),sacctime),WindowSize);
% %saccspeed(:,:,2) = smooth(speedcalc(saccades(:,:,2),sacctime),WindowSize);
% espeed(:,:,3) = smooth(speedcalc(epos(:,:,3),trialtime),WindowSize);

%% Calculate speed and acceleration

Msaccspeed(:,:,1) = smooth(speedcalc(Msaccades(:,:,1),Msacctime),WindowSize);
Msaccspeed(:,:,2) = smooth(speedcalc(Msaccades(:,:,2),Msacctime),WindowSize);
Msaccspeed(:,:,3) = vectorise(Msaccspeed(:,:,1),Msaccspeed(:,:,2)); %abs or not?

Msaccaccel(:,:,1) = smooth(accelcalc(Msaccspeed(:,:,1),Msacctime),WindowSize);
Msaccaccel(:,:,2) = smooth(accelcalc(Msaccspeed(:,:,2),Msacctime),WindowSize);
Msaccaccel(:,:,3) = smooth(accelcalc(Msaccspeed(:,:,3),Msacctime),WindowSize);

%% Clear unsmoothed section of data

Msaccades = Msaccades(:,WindowSize:end,:);
Msaccspeed = Msaccspeed(:,WindowSize:end,:);
Msaccaccel = Msaccaccel(:,WindowSize:end,:);

Msaccevent = Msaccevent(:,WindowSize:end,:);

Msacctime = Msacctime(:,WindowSize:end);

%% Direction predictor

saccdirection_simple;

% % Fit: 'untitled fit 1'.
% [xData, yData] = prepareCurveData( beari, bear );
% 
% % Set up fittype and options.
% ft = fittype( 'poly1' );
% opts = fitoptions( ft );
% opts.Lower = [-Inf -Inf];
% opts.Upper = [Inf Inf];
% 
% % Fit model to data.
% [fitresult, gof] = fit( xData, yData, ft, opts );

%% Clean up

clear filename