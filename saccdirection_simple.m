[y x z] = size(Msaccades);

bearWindow = 4;

for j = 1:y
    for i = 2:x
    	if Msaccevent(j,i) == 1
            if Msaccevent(j,i-1) == 0
                Msaccdetected(j,1,1) = mean(Msaccades(j,i:i+bearWindow-1,1));
                Msaccdetected(j,1,2) = mean(Msaccades(j,i:i+bearWindow-1,2));
            end
        end
    end
end

% %code for finding mean of bearings to first point- actually worse!
% for j = 1:y
%     for i = 2:x
%     	if Msaccevent(j,i) == 1
%             if Msaccevent(j,i-1) == 0
%                 beartemp = [];
%                 for p = 0:bearWindow-1
% beartemp = [beartemp atan(Msaccades(j,i + p,2)/Msaccades(j,i + p,1))];
% beari(j,1) = mean(beartemp);
%                 end
%             end
%         end
%     end
% end

for j = 1:y
    beari(j,1) = atan(Msaccdetected(j,1,2)/Msaccdetected(j,1,1)); %#ok<SAGROW>
    bear(j,1) = atan(Msaccend(j,1,2)/Msaccend(j,1,1)); %#ok<SAGROW>
end