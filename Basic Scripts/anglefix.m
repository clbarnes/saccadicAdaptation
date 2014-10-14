function out = anglefix(in)

angle = in;

while angle >= 360 || angle < 0
    
    if angle < 0
        angle = angle + 360;
    end
    
    if angle >= 360
        angle = angle - 360;
    end
    
end

out = angle;