AccelThreshes = [700 5000];
SaccErrorPC = 1.5;

ATtrial = 0;

while abs(AccelThreshes(1,2)-AccelThreshes(1,1)) > 50
    
    ATtrial = ATtrial+1;
    
    AccelThreshDiff(ATtrial) = abs(AccelThreshes(1,2)-AccelThreshes(1,1));
    
    AccelThresh = mean(AccelThreshes);
    
    allcalc_4
    
    if SaccErrorPC < 5
        AccelThreshes(1,2) = mean(AccelThreshes);
    end
    
    if SaccErrorPC > 5
        AccelThreshes(1,1) = mean(AccelThreshes);
    end
   
    fprintf('Iteration %d\n',ATtrial);
    fprintf('AccelThreshDiff %d\n\n',AccelThreshDiff(ATtrial));
    
    plot(1:ATtrial,AccelThreshDiff); drawnow;
    
end