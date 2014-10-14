function out = cumufreq(data,bins)

%Plots graph of cumulative frequency with specified number of bins.

datumno = length(data); DataMax = max(data);

ppn = linspace(0,1,bins); count = zeros(length(ppn));

for i = 1:length(ppn)
    
    for datum = 1:datumno
        if data(datum) <= ppn(i)*DataMax
            
            count(i) = count(i) + 1;
            
        end
    end
end

plot(ppn*DataMax,(count/length(data))*100); ylabel('Cumulative Frequency (%%)');
            
            