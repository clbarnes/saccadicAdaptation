filename = input('Data file name: ', 's');
eval(['[D,R] = DATAFILE_Read(''' filename ''')'])

WindowSize = 9;

epos = D.FrameDataExp.EyePosition;
eposX = epos(:,:,1); eposY = epos(:,:,2);
trialtime = D.FrameDataExp.TrialTime;

espeedX = smooth(speedcalc(eposX,trialtime),WindowSize);
espeedY = smooth(speedcalc(eposY,trialtime),WindowSize);
espeed = vectorise(espeedX,espeedY);

eaccelX = accelcalc(espeedX,trialtime);
eaccelY = accelcalc(espeedY,trialtime);
eaccel = vectorise(eaccelX,eaccelY);

saccevent = D.FrameDataExp.SaccadeEvent;

%saccextractor; sacc_calc;

clear R filename savename

savename = input('Save file as: ', 's');
eval(['save ' savename ]);