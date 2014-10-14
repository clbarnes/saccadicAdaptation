subplot(2,1,1), plot(1:4001,trialtime(1,1:4001));

trialtimegrad = zeros(1,4001);

for i = 2:4001
    trialtimegrad(1,i) = trialtime(1,i)-trialtime(1,i-1);
end

subplot(2,1,2), plot(1:4000,trialtimegrad(1,2:4001));

clear i