function out = cumufreqcompare(data,bins)

%Plots graph of cumulative frequency with specified number of bins, for
%multiple horizontal data sets concatenated vertically.

[setno,datumnomax] = size(data); datumno = zeros(setno,1);

DataMax = zeros(setno,1); datumno = zeros(setno,1);

ppn = linspace(0,1,bins); count = zeros(setno,length(ppn));

for set = 1:setno
    
    DataMax(set) = max(data(set,:));
    
    for datum = 1:datumnomax        
        if isnan(data(set,datum)) == 0
            datumno(set) = datumno(set) + 1;
        end        
    end
    
    for i = 1:length(ppn)
        
        for datum = 1:datumno(set)
            if data(set,datum) <= ppn(i)*DataMax(set)
                
                count(set,i) = count(set,i) + 1;
                
            end
        end
    end
    
end

for set = 1:setno
plot(ppn*DataMax(set),(count(set,:)/datumno(set))*100,'color',[rand rand rand]);
hold on;
end

ylabel('Cumulative Frequency (%%)');
xlabel('Fixation Length (seconds)');

TrialBlockList = {};

for set = 1:setno
    TrialBlock = sprintf('Trial Block %d',set);
    TrialBlockList = [TrialBlockList TrialBlock];
end

legend(TrialBlockList);

hold off;

