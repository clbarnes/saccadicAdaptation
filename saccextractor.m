buffer = 10 + WindowSize;

sacc_no = 1;
[y x z] = size(epos);

thissacc = [];

saccades = nan(1,100,3);
%saccadesevent = zeros(trialno,100);
sacctime = nan(1,150);
saccend = nan(1,2);

%% Extract saccade, normalise origin

for j = 1:y
    for i = buffer:x-buffer
        if esaccades(j,i) ~= 0 %if a saccade is happening
            if esaccades(j,i-1) == 0 %if it is the first saccade reading
                start = i-buffer; j1 = j;
            elseif esaccades(j,i+1) == 0 %if it is the last saccade reading
                if j == j1
                finish = i+buffer;
                thissacc = epos(j,start:finish,:);
                
        saccstart(1,1) = mean(thissacc(1,1:WindowSize,1));
        saccstart(1,2) = mean(thissacc(1,1:WindowSize,2));
        
        thissacc(1,:,1) = thissacc(1,:,1) - saccstart(1,1); %normalise
        thissacc(1,:,2) = thissacc(1,:,2) - saccstart(1,2,1);
        
        saccend(sacc_no,1) = mean(thissacc(1,end-WindowSize:end,1));
        saccend(sacc_no,2) = mean(thissacc(1,end-WindowSize:end,2));
       
        saccades(sacc_no,1:length(thissacc),1:2) = thissacc; 
        saccevent(sacc_no,1:length(thissacc)) = esaccades(j,start:finish);
        
        sacctime(sacc_no,1:length(thissacc)) = trialtime(j,start:finish);
    
       thissacc = [];
        sacc_no = sacc_no + 1;
                end
            end
        end
    end
end

sacc_no = sacc_no - 1;

%% Purge 0s from sacctime, saccades; normalise

[y x z] = size(saccades);

for j = 1:sacc_no
    sacctime(j,:) = sacctime(j,:) - sacctime(j,1);
    for i = 2:x
        if sacctime(j,i) <= 0
            sacctime(j,i) = nan;
        end
        for k = 1:z
            if saccades(j,i,k) == 0
                saccades(j,i,k) = nan;
            end
        end
    end
end
         
clear j i thissacc saccstart start finish g f maxtime