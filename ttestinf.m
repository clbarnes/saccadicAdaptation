function results = ttestinf(data)

[setno,datumno] = size(data);

if setno ~= 4
    error('Requires 4 data sets');
end

% out = ['X', 'TrialBlock1', 'TrialBlock2', 'TrialBlock3', 'TrialBlock4';
%     'TrialBlock1', 'O', 'X', 'X', 'X';
%     'TrialBlock2', 'O', 'X', 'X', 'X';
%     'TrialBlock3', 'O', 'O', 'X', 'X';
%     'TrialBlock4', 'O', 'O', 'O', 'X'];

results = nan(setno);

for X = 1:setno
    for Y = 1:setno
        if Y > X
        [~,results(Y,X)] = ...
            ttest2(data(X,:),data(Y,:),0.05,'both','equal');
        end
    end
end

end