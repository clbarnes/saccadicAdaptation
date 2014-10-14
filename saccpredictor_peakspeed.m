[y x z] = size(Msaccspeed);

%% Find peak speed

peakspeed = zeros(y,1);
peakspos = zeros(y,1,z);

for j = 1:y
    for i = (floor(WindowSize/2)+1):x
        if Msaccevent(j,i) == 1
            if Msaccspeed(j,i,3) > peakspeed(j,1)
                peakspeed(j,1) = Msaccspeed(j,i,3);
                for k = 1:3
                peakspos(j,1,k) = mean(Msaccades(j,(i - floor(WindowSize/2)):(i + ceil(WindowSize/2)),k)); 
                end
            end
        end
    end
end

%% Find amplitude

disp = vectorise(Msaccend(:,1,1),Msaccend(:,1,2));

%% Evaluate data, find coefficients
[xData, yData] = prepareCurveData( peakspeed, disp );

% Set up fittype and options.
ft = fittype( 'poly1' );
opts = fitoptions( ft );
opts.Lower = [-Inf -Inf];
opts.Robust = 'LAR';
opts.Upper = [Inf Inf];
opts.Normalize = 'on';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

p1 = 2.803064702038850; %for 'firsttry' data set
p2 = 4.349729638261515;

%% Magnitude predictor

%this doesn't work, why doesn't it work- suspect normalising of data
% for j = 1:y
%     predicteddisp(j,1) = p1*peakspeed(j,1) + p2
% end

%% Cleanup
clear x y j i