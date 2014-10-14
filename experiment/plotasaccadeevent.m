%Showcase the obvious superiority of the savitsky-golay filter
%USE DATA FROM SUBJECT 0_SHORT

%% Initialise variables

TrialTime = subject0.D.FrameDataExp.TrialTime;
EyeSpeed = subject0.EyeSpeed; [trialno binno dno] = size(EyeSpeed);
EyePosition = dispcalc(subject0.D.FrameDataExp.EyePosition);
EyeSpeedSmooth = nan(trialno,binno,dno);

trial = 124;
binmin = 1525; binmax = 1650;

%% Generate diff speed
EyeSpeedRaw = speedcalc_2(EyePosition,TrialTime);
for i = 1:3
    EyeSpeedSmooth(:,:,i) = smoothMag(EyeSpeedRaw(:,:,i),5);
end

%% Convert to degrees
EyeSpeedDeg = nan(trialno,binno);
EyeSpeedSmoothDeg = nan(trialno,binno);
EyeSpeedRawDeg = nan(trialno,binno);

for trialcount = 1:trialno
    for bin = 1:binno
        EyeSpeedDeg(trialcount,bin) = dist2deg(EyeSpeed(trialcount,bin,3));
        EyeSpeedSmoothDeg(trialcount,bin) = dist2deg(EyeSpeedSmooth(trialcount,bin,3));
        EyeSpeedRawDeg(trialcount,bin) = dist2deg(EyeSpeedRaw(trialcount,bin,3));
    end
end

%% Plot
subplot(2,1,1),
plot((TrialTime(trial,binmin:binmax)-TrialTime(trial,binmin))*1000,...
    EyeSpeedDeg(trial,binmin:binmax)/500,':','color','black'); hold all;
plot((TrialTime(trial,binmin:binmax)-TrialTime(trial,binmin))*1000,...
    subject0.D.FrameDataExp.SaccadeEvent(trial,binmin:binmax),'-','color','black');
%xlim([0 (TrialTime(trial,binmax)-TrialTime(trial,binmin))*1000]);
ylim([-0.2 1.2]);
legend('Speed Profile','Online');
set(gca, 'YTick', [0 1]);
set(gca, 'YTickLabel', {'No','Yes'}); hold off;

subplot(2,1,2),
plot((TrialTime(trial,binmin:binmax)-TrialTime(trial,binmin))*1000,...
    EyeSpeedDeg(trial,binmin:binmax)/500,':','color','black'); hold all;
plot((TrialTime(trial,binmin:binmax)-TrialTime(trial,binmin))*1000,...
    subject0.SaccadeEventNH(trial,binmin:binmax),'-','color','black');
%xlim([0 (TrialTime(trial,binmax)-TrialTime(trial,binmin))*1000]);
ylim([-0.2 1.2]);
legend('Speed Profile','Nyström-Holmqvist');
set(gca, 'YTick', [0 1]); 
set(gca, 'YTickLabel', {'No','Yes'}); hold off;

suplabel('Saccade In Progress','y');
suplabel('Time ( ms )','x');