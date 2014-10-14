filename = input('Data file name: ', 's');
eval(['[D,R] = DATAFILE_Read(''' filename ''')'])

epos = D.FrameDataExp.EyePosition;
eposX = epos(:,:,1); eposY = epos(:,:,2);
trialtime = D.FrameDataExp.TrialTime;

espeedX = speedcalc(eposX,trialtime); espeedY = speedcalc(eposY,trialtime);
espeed = vectorise(espeedX,espeedY);

eaccelX = accelcalc(espeedX,trialtime); eaccelY = accelcalc(espeedY,trialtime);
eaccel = vectorise(eaccelX,eaccelY);

saccevent = D.FrameDataExp.SaccadeEvent;

saccextractor; sacc_calc;

clear R filename savename

savename = input('Save file as: ', 's');
eval(['save ' savename ]);