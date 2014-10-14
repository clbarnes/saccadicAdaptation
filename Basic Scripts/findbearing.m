function bearing = findbearing(X1,Y1,X2,Y2)

if X2 > X1
    if Y2 > Y1
        bearing = 90 - atand((Y2-Y1)/(X2-X1));
    else
        bearing = 90 + atand((Y1-Y2)/(X2-X1));   
    end
else
    if Y2 > Y1
        bearing = 270 + atand((Y2-Y1)/(X1-X2));
    else
        bearing = 270 - atand((Y1-Y2)/(X1-X2));
    end
end

end