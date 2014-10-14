%function [Tol PCdropped] = directioncountTolFind(SaccBear)

saccno = length(SaccBear);

Toli = -0.1; i = 0; Agree = 0; Detected = saccno;

while Agree < 0.95*Detected
    
    Agree = 0; Detected = 0;
    
    Toli = Toli + 0.1;  i = i+1;
    
    for sacc = 1:saccno
        
        %% count for initial bearing
        
        HealthySaccade = 'none';
        
        if 0 + Toli <= SaccBear(sacc,1) &&...
                SaccBear(sacc,1) < 90 - Toli
            HealthySaccade = 'NE';
        end
        if 90 + Toli <= SaccBear(sacc,1) &&...
                SaccBear(sacc,1) < 180 - Toli
            HealthySaccade = 'SE';
        end
        if 180 + Toli <= SaccBear(sacc,1) &&...
                SaccBear(sacc,1) < 270 - Toli
            HealthySaccade = 'SW';
        end
        if 270 + Toli <= SaccBear(sacc,1) &&...
                SaccBear(sacc,1) < 360 - Toli
            HealthySaccade = 'NW';
        end
        
        %% count for final bearing
        
        HealthySaccade2 = 'none';
        
        if 0<= SaccBear(sacc,2) &&...
                SaccBear(sacc,2) < 90 
            HealthySaccade2 = 'NE';
        end
        if 90 <= SaccBear(sacc,2) &&...
                SaccBear(sacc,2) < 180
            HealthySaccade2 = 'SE';
        end
        if 180 <= SaccBear(sacc,2) &&...
                SaccBear(sacc,2) < 270
            HealthySaccade2 = 'SW';
        end
        if 270 <= SaccBear(sacc,2) &&...
                SaccBear(sacc,2) < 360
            HealthySaccade2 = 'NW';
        end
        
        if strcmp(HealthySaccade2, HealthySaccade) == 1;
            Agree = Agree + 1;
        end
        
        if strcmp(HealthySaccade,'none') == 0
            Detected = Detected + 1;
        end
        
    end
    
end

Tol = Toli; PCdropped = 100-(Detected/saccno)*100;