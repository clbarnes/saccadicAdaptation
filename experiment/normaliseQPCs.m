for i = 1:5
    if i == 3
        continue
    end

eval(['QPCnormfactor_' num2str(i) ' = mean(sum(QuadrantsPC_' num2str(i) '(1:2,1:2)''));'...
    'QuadrantsPCnorm_' num2str(i) ' = (QuadrantsPC_' num2str(i) './QPCnormfactor_' num2str(i) ')*2;']);

end

plotresults([1 2],QuadrantsPCnorm_1,QuadrantsPCnorm_2,QuadrantsPCnorm_4,QuadrantsPCnorm_5);