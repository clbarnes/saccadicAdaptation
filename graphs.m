%% plot different windowsizes on error vs. truesacccount
% 
% figure
% 
% for WindowSize = 1:20
%     scatter(SaccErrorPC(WindowSize,:),TrueSaccCount(WindowSize,:),10,[rand rand rand]); hold on;
% end
%     
% hold off;

%% plot speed profiles against saccadeeventC

[trialno,binno] = size(TrialTime);

trial = 1;

for trial = 1:50
    figure, %plotyy(TrialTime(trial,:),EyeSpeed(trial,:,3),...
        %TrialTime(trial,:),EyeAccel(trial,:,3)); hold all;
        plot(TrialTime(trial,:),EyeSpeed(trial,:,3)); hold all;
    plot(TrialTime(trial,:),SaccadeEventC(trial,:)*100,'color','red');
    %plot(TrialTime(trial,:),SaccadeEventC(trial,:).*(3.38+19.8*2.54),'color','red');
    %plot(TrialTime(trial,:),SaccadeEventC(trial,:).*SpeedOffThresh,'color','green'); hold off;
end

%% Plot all the things

% [trialno, binno, dno] = size(EyePosition);
% 
% for trial = 1:trialno
% figure, subplot(2,1,1), plot(abs(EyeSpeed(trial,:,3))); hold all; plot(ones(1,4001)*SpeedThresh,'color','red');
%     subplot(2,1,2), plot(abs(EyeAccel(trial,:,3))); hold all; plot(ones(1,4001)*AccelThresh,'color','red');
%     hold off;
% end
%         

%% Count saccades over criterion length

% [Ptrialno,Saccno] = size(SaccLength);
% TrueSaccCount = zeros(Ptrialno,1);
% BadSaccCount = zeros(Ptrialno,1);
% SaccPpn = zeros(Ptrialno,1);
% L = 0.01; %seconds
% 
% for Ptrial = 1:Ptrialno
%     for Sacc = 1:Saccno
%         if SaccLength(Ptrial,Sacc) == 0
%             SaccLength(Ptrial,Sacc) = nan;
%         end
%     end
% end
% 
% for Ptrial = 1:Ptrialno
%     for Sacc = 1:Saccno
%         if SaccLength(Ptrial,Sacc) >= L
%             TrueSaccCount(Ptrial,1) = TrueSaccCount(Ptrial) + 1;
%         end
% 
%         if SaccLength(Ptrial,Sacc) <= L
%             BadSaccCount(Ptrial,1) = BadSaccCount(Ptrial) + 1;
%         end
%     end
%     
%     SaccPpn(Ptrial,1) = TrueSaccCount(Ptrial,1) / BadSaccCount(Ptrial,1);
% end
% 
% subplot(4,1,4), plot(10:-0.1:0,SaccPpn); title('Proportion of Saccades longer than : shorter than the criterion');
% subplot(4,1,2), plot(10:-0.1:0,TrueSaccCount); title('Number of Saccades longer than the criterion');
% subplot(4,1,3), plot(10:-0.1:0,BadSaccCount); title('Number of Saccades shorter than the criterion');
% subplot(4,1,1), plot(10:-0.1:0,TrueSaccCount + BadSaccCount); title('Total detected saccades');

%% Histogram of saccade lengths for different P values

% [Ptrialno,Saccno] = size(SaccLength);
% 
% for Ptrial = 1:Ptrialno
%     for Sacc = 1:Saccno
%         if SaccLength(Ptrial,Sacc) == 0
%             SaccLength(Ptrial,Sacc) = nan;
%         end
%     end
% end
% 
% for Ptrial = 1:Ptrialno
%     figure, hist(SaccLength(Ptrial,:));
% end

%% Plot stable sections of displacement

% [trialno, binno, dno] = size(EyePositionStable);
% EyePositionStable2 = EyePositionStable;
% 
% for trial = 1:trialno
%         if trial == 7
%             EyePositionStable2(trial,:,:) = nan(binno,dno);
%     end
%     if trial == 19
%             EyePositionStable2(trial,:,:) = nan(binno,dno);
%     end
%     if trial == 23
%             EyePositionStable2(trial,:,:) = nan(binno,dno);
%     end
%     if trial == 49
%             EyePositionStable2(trial,:,:) = nan(binno,dno);
%     end
%     if trial == 60
%             EyePositionStable2(trial,:,:) = nan(binno,dno);
%     end
%     if trial == 81
%     EyePositionStable2(trial,:,:) = nan(binno,dno);
%     end
%     
% plot(EyePositionStable2(trial,:,3)); hold all;
% end

%% Plot Stable sections of Accel and Speed profiles

% [trialno, binno, dno] = size(EyeAccelStable);
% EyeSpeedStable2 = EyeSpeedStable;
% EyeAccelStable2 = EyeAccelStable;
% 
% for trial = 1:trialno
%     if trial == 7
%             EyeSpeedStable2(trial,:,:) = nan;
%     EyeAccelStable2(trial,:,:) = nan;
%     end
%     if trial == 19
%             EyeSpeedStable2(trial,:,:) = nan;
%     EyeAccelStable2(trial,:,:) = nan;
%     end
%     if trial == 23
%             EyeSpeedStable2(trial,:,:) = nan;
%     EyeAccelStable2(trial,:,:) = nan;
%     end
%     if trial == 49
%             EyeSpeedStable2(trial,:,:) = nan;
%     EyeAccelStable2(trial,:,:) = nan;
%     end
%     if trial == 60
%             EyeSpeedStable2(trial,:,:) = nan;
%     EyeAccelStable2(trial,:,:) = nan;
%     end
%     if trial == 81
%     EyeSpeedStable2(trial,:,:) = nan;
%     EyeAccelStable2(trial,:,:) = nan;
%     end
%     
%     subplot(2,1,1), plot(EyeSpeedStable2(trial,:,3)); hold all;
%     subplot(2,1,2), plot(EyeAccelStable2(trial,:,3)); hold all;
%     
%     
% end

%% plot all saccade acceleration profiles

% for j = 0:floor(length(Msaccend)/9);
%     figure
%     for i = 1:9
%         subplot(3,3,i), plot(Msacctime(i+j*9,:),Msaccaccel(i+j*9,:,3)); hold on;
%     end
%     hold off;
% end

%% plot all saccade speed profiles

% for j = 0:floor(length(Msaccend)/9);
%     figure
%     for i = 1:9
%         subplot(3,3,i), plot(Msacctime(i+j*9,:),Msaccspeed(i+j*9,:,3)); hold on;
%     end
%     hold off;
% end

%% plot all Msaccades

% for j = 0:floor(length(Msaccend)/9);
% figure 
% for i = 1:9
% subplot(3,3,i), plot(Msaccades(i+j*9,:,1),Msaccades(i+j*9,:,2)); hold on;
% set(gca,'DataAspectRatio',ones(1,3))
% end
% hold off;
% end

%% plot all saccades

% for j = 0:floor(length(saccend)/9);
%     figure
%     for i = 1:9
%         subplot(3,3,i), plot(saccades(i+j*9,:,1),saccades(i+j*9,:,2)); hold on;
%         set(gca,'DataAspectRatio',ones(1,3))
%     end
%     hold off;
% end

%% Compare saccevent w/ displacement

% for i = 0:5:20
%     figure;
%     for j = 1:5
%         subplot(5,1,j); plot(epos(i + j,:,3)); hold on; plot(esaccades(i+j,:),'color','red');
%     end
% end

%% Compare saccevent w/ speed
% 
% for i = 0:5:20
%     figure;
%     for j = 1:5
%         subplot(5,1,j); plot(vectorise(smooth(speedcalc(epos,:,1));
%         hold on; plot(esaccades(i+j,:),'color','red');
%     end
% end
    