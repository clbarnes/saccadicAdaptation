WindowSize = 9;

saccspeed(:,:,1) = smooth(speedcalc(saccades(:,:,1),sacctimes),WindowSize);
saccspeed(:,:,2) = smooth(speedcalc(saccades(:,:,2),sacctimes),WindowSize);
saccspeed(:,:,3) = vectorise(saccspeed(:,:,1),saccspeed(:,:,1));

saccaccel(:,:,1) = accelcalc(saccspeed(:,:,1),sacctimes);
saccaccel(:,:,2) = accelcalc(saccspeed(:,:,1),sacctimes);
saccaccel(:,:,3) = vectorise(saccaccel(:,:,1),saccaccel(:,:,1));