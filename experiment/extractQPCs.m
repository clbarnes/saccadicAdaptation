%Start in /experiment

for i = 1:5
    if i == 3
        continue
    end

eval(['cd Subject_' num2str(i) '; '...
    'load subject' num2str(i) '; '...
    'QuadrantsPC_' num2str(i) ' = subject' num2str(i) '.QuadrantsPC; '...
    'clear subject' num2str(i) ' ; '...
    'cd ..']);

end

save QuadrantsPCs

plotresults([1 2],QuadrantsPC_1,QuadrantsPC_2,QuadrantsPC_4,QuadrantsPC_5);

clear all