function practicetimes(filename)

[in txt raw] = xlsread(filename); 
txt; raw;

s = size(in);

MoTu = 0; MoWe = 0; MoTh = 0; MoFr = 0;
TuWe = 0; TuTh = 0; TuFr = 0;
WeTh = 0; WeFr = 0;
ThFr = 0;

%% Monday-Tuesday
for i = 1:s(1,1)
    MoTu = MoTu + in(i,1) + in(i,2);
    if in(i,1) + in(i,2) >= 2
        MoTu = MoTu - 1;
    end
end

%% Monday - Wednesday
for i = 1:s(1,1)
    MoWe = MoWe + in(i,1) + in(i,3);
    if in(i,1) + in(i,3) >= 2
        MoWe = MoWe - 1;
    end
end

%% Monday - Thursday
for i = 1:s(1,1)
    MoTh = MoTh + in(i,1) + in(i,4);
    if in(i,1) + in(i,4) >= 2
        MoTh = MoTh - 1;
    end
end

%% Monday - Friday
for i = 1:s(1,1)
    MoFr = MoFr + in(i,1) + in(i,5);
    if in(i,1) + in(i,5) >= 2
        MoFr = MoFr - 1;
    end
end

%% Tuesday - Wednesday
for i = 1:s(1,1)
    TuWe = TuWe + in(i,2) + in(i,3);
    if in(i,2) + in(i,3) >= 2
        TuWe = TuWe - 1;
    end
end

%% Tuesday - Thursday
for i = 1:s(1,1)
    TuTh = TuTh + in(i,2) + in(i,4);
    if in(i,2) + in(i,4) >= 2
        TuTh = TuTh - 1;
    end
end

%% Tuesday - Friday
for i = 1:s(1,1)
    TuFr = TuFr + in(i,2) + in(i,5);
    if in(i,1) + in(i,5) >= 2
        TuFr = TuFr - 1;
    end
end

%% Wednesday - Thursday
for i = 1:s(1,1)
    WeTh = WeTh + in(i,3) + in(i,4);
    if in(i,3) + in(i,4) >= 2
        WeTh = WeTh - 1;
    end
end

%% Wednesday - Friday
for i = 1:s(1,1)
    WeFr = WeFr + in(i,3) + in(i,5);
    if in(i,3) + in(i,5) >= 2
        WeFr = WeFr - 1;
    end
end

%% Thursday - Friday
for i = 1:s(1,1)
    ThFr = ThFr + in(i,4) + in(i,5);
    if in(i,4) + in(i,5) >= 2
        ThFr = ThFr - 1;
    end
end

MoTu
MoWe
MoTh
MoFr
TuWe
TuTh
TuFr
WeTh
WeFr
ThFr