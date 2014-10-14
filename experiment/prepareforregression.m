PenalisedHemi = [];

for i = 1:5
    
    if i == 3
        continue
    end
    
    eval(['PenalisedHemi_' num2str(i) ' = sum(QuadrantsPC_' num2str(i) '(:,1:2)'');'...
    'PenalisedHemi = [PenalisedHemi; PenalisedHemi_' num2str(i) '];'])
end

[subjectno,TrialBlockNo] = size(PenalisedHemi);

PenalisedHemiCat = reshape(PenalisedHemi,1,subjectno*TrialBlockNo);

numbers = nan(1,subjectno*TrialBlockNo);

for TrialBlock = 1:TrialBlockNo
    for subject = 1:subjectno
        numbers((TrialBlock-1)*subjectno+subject) = TrialBlock - subject*0.00000000001;
    end
end
