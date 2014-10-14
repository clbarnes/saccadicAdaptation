function [D,R,V] = DATAFILE_Read1(FileName,Trial0,Trial1,FrameDataFlag)
% Reads experimental data for trials from a file (Version 1).
%   [D,R,V] = DATAFILE_Read1(FileName,Trial0,Trial1,FrameDataFlag)
%   D = Data
%   R = Return code (Boolean success)
%   V = Variable names

if( nargin ~= 4 )
    error('Invalid number of input parameters.');
end

% Version number.
DATAFILE_VERSION = 1;

% Data types.
DATAFILE_HEADER = 72;
DATAFILE_TRIAL  = 84;
DATAFILE_FRAME  = 70;
DATAFILE_FILE   = 88;

DATAFILE_STRLEN = 40;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open file and determines file size in bytes.           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FID = fopen(FileName,'r');

if( FID == -1 )
    disp(sprintf('Cannot open file: %s',FileName));
    D = [ ];
    R = false;
    V = { };
    return;
end

% Seek to end of file to determine file size.
if( fseek(FID,0,'eof') ~= 0 )
    fclose(FID);
    disp(sprintf('Cannot find end of file: %s',FileName));
    D = [ ];
    R = false;
    V = { };
    return;
end

FileSize = ftell(FID);

% Rewind to start of file.
if( fseek(FID,0,'bof') ~= 0 )
    fclose(FID);
    disp(sprintf('Cannot find start of file: %s',FileName));
    D = [ ];
    R = false;
    V = { };
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read version number for data file                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DataType = fread(FID,1,'uchar');

if( DataType ~= DATAFILE_HEADER )
    fclose(FID);
    disp(sprintf('File parsing error (header): %s',FileName));
    D = [ ];
    R = false;
    V = { };
    return;
end

VersionNumber = fread(FID,1,'uint8');

if( VersionNumber ~= DATAFILE_VERSION )
    fclose(FID);
    disp(sprintf('Version mismatch (datafile=%d, function=%d)',VersionNumber,DATAFILE_VERSION));
    D = [ ];
    R = false;
    V = { };
    return;
end

TrialColumns = fread(FID,1,'int');

if( TrialColumns == 0 )
    fclose(FID);
    disp(sprintf('Zero columns in trial data'));
    D = [ ];
    R = false;
    V = { };
    return;
end

s = fread(FID,DATAFILE_STRLEN,'uint8=>char')';
TrialName = sprintf('%s',s);

TrialVariables = fread(FID,1,'int');

c = 1;

VC = 0;

for v=1:TrialVariables
    TrialVariableDim(v,:) = fread(FID,3,'int');
    TrialVariableColumn(v) = c;
    TrialVariableItems(v) = TrialVariableDim(v,1) * TrialVariableDim(v,2) * TrialVariableDim(v,3);
    c = c + TrialVariableItems(v);
    s = fread(FID,DATAFILE_STRLEN,'uint8=>char')';
    TrialVariableName{v} = deblank(s));
    VC = VC + 1;
    V{VC} = TrialVariableName{v};
end

FrameBlocks = fread(FID,1,'int');

for f=1:FrameBlocks
    FrameDim(f,:) = fread(FID,2,'int');
    
    s = fread(FID,DATAFILE_STRLEN,'uint8=>char')';
    FrameName{f} = sprintf('%s',s);

    FrameVariables(f) = fread(FID,1,'int');
    
    c = 1;

    for v=1:FrameVariables(f)
        FrameVariableDim(f,v,:) = fread(FID,3,'int');
        FrameVariableColumn(f,v) = c;
        FrameVariableItems(f,v) = FrameVariableDim(f,v,1) * FrameVariableDim(f,v,2) * FrameVariableDim(f,v,3);
        c = c + FrameVariableItems(f,v);
        s = fread(FID,DATAFILE_STRLEN,'uint8=>char')';
        FrameVariableName{f,v} = deblank(s);
        VC = VC + 1;
        V{VC} = sprintf('%s.%s',FrameName{f},FrameVariableName{f,v});
    end
end

if( (Trial0+Trial1) == 0 )
    fclose(FID);
    D = [ ];
    R = true;
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read trial data and have a peek at frame data.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EOF = 0;
TrialInput = 0;
TrialOutput = 0;
FrameRows = zeros(1,FrameBlocks);

while( EOF == 0 )
    DataType = fread(FID,1,'uchar');
    
    if( feof(FID) || (DataType == DATAFILE_FILE) )
        EOF = 1;
        continue;
    end
    
    if( DataType ~= DATAFILE_TRIAL )
        fclose(FID);
        disp(sprintf('File parsing error (trial): %s (Trial=%d)',FileName,TrialInput));
        D = [ ];
        R = false;
        V = { };
        return;
    end

    TrialInput = TrialInput + 1;
    TrialNumber = fread(FID,1,'int');
    
    if( TrialNumber ~= TrialInput )
        %fclose(FID);
        disp(sprintf('Trial numbers out of sequence (Expected=%d, Read=%d): %s',TrialInput,TrialNumber,FileName));
        TrialInput = TrialNumber;
        %D = [ ];
        %R = false;
        %V = { };
        %return;
    end
    
    % Read trial data.
    T = fread(FID,TrialColumns,'double');
    
    % Is trial in the range to be read?
    if( (Trial0 == 0) || (TrialInput >= Trial0) )
        TrialOutput = TrialOutput + 1;
        TrialList(TrialOutput) = TrialInput;
        TrialData(TrialOutput,:) = T;
        
        % Save position of frame data to read it later.
        FrameDataPosition(TrialOutput) = ftell(FID);
    end
    
    disp(sprintf('Trial %d/%d',TrialOutput,TrialInput))
    
    % Take a peek at frame data without reading it.
    for FrameBlock=1:FrameBlocks
        DataType = fread(FID,1,'uchar');
        
        if( DataType ~= DATAFILE_FRAME )
            fclose(FID);
            disp(sprintf('File parsing error (frame): %s (Trial=%d, Frame=%d)',FileName,TrialInput,FrameBlock));
            D = [ ];
            R = false;
            V = { };
            return;
        end
        
        % What is the maximum number of rows in this frame data?
        FrameSize = fread(FID,2,'int')';
        if( (Trial0 == 0) || (TrialInput >= Trial0) )
            if( FrameRows(FrameBlock) < FrameSize(1) )
                FrameRows(FrameBlock) = FrameSize(1);
            end
        end
        
        if( feof(FID) )
            fclose(FID);
            disp(sprintf('Unexpected end of file (frame): %s (Trial=%d, Frame=%d)',FileName,TrialInput,FrameBlock));
            D = [ ];
            R = false;
            V = { };
            return;
        end

        % Total number of bytes in this frame data.
        FrameBytes = FrameSize(1) * FrameSize(2) * 8;
        
        % Seek over frame data without reading it.
        if( fseek(FID,FrameBytes,'cof') ~= 0 )
            fclose(FID);
            disp(sprintf('Cannot seek to position in file (frame): %s (Trial=%d, Frame=%d)',FileName,TrialInput,FrameBlock));
            D = [ ];
            R = false;
            V = { };
            return;
        end
    end
    
    % Stop if we've read all trials in the requested range.
    if( (Trial1 ~= 0) && (TrialInput == Trial1) )
        break;
    end
end    

Trials = TrialOutput;
disp(sprintf('%d Trials',Trials));

D.Trials = Trials;
D.TrialNumber = TrialList;

% Put trial data into output argument for function.
for v=1:TrialVariables
    if( TrialVariableDim(v,1) == 1 )
        eval(sprintf('D.%s = TrialData(:,%d:%d);',TrialVariableName{v},TrialVariableColumn(v),(TrialVariableColumn(v)+TrialVariableItems(v)-1)));
    else
        items = TrialVariableDim(v,2) * TrialVariableDim(v,3);
        for i=1:TrialVariableDim(v,1)
            offset = ((i-1) * items);
            eval(sprintf('D.%s(1:%d,%d,1:%d) = TrialData(:,%d:%d);',TrialVariableName{v},Trials,i,items,TrialVariableColumn(v)+offset,(TrialVariableColumn(v)+offset+items-1)));
        end
    end
end

if( FrameDataFlag )
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Allocate frame data matrix.                            %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for f=1:FrameBlocks
        eval(sprintf('D.%s.Frames = zeros(%d,1);',FrameName{f},Trials));
        for v=1:FrameVariables(f)
            if( FrameVariableDim(f,v,1) == 1 )
                eval(sprintf('D.%s.%s = zeros([ %d %d %d ]);',FrameName{f},FrameVariableName{f,v},Trials,FrameRows(f),FrameVariableItems(f,v)));
            else
                items = FrameVariableDim(f,v,2) * FrameVariableDim(f,v,3);
                eval(sprintf('D.%s.%s = zeros([ %d %d %d %d ]);',FrameName{f},FrameVariableName{f,v},Trials,FrameRows(f),FrameVariableDim(f,v,1),items));
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Loop through each trial reading frame data.            %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for Trial=1:Trials
        disp(sprintf('Trial %d / %d',Trial,Trials))

        if( fseek(FID,FrameDataPosition(Trial),'bof') ~= 0 )
            fclose(FID);
            disp(sprintf('Cannot seek to position in file: %s',FileName));
            D = [ ];
            R = false;
            V = { };
            return;
        end

        for f=1:FrameBlocks
            DataType = fread(FID,1,'uchar');

            if( DataType ~= DATAFILE_FRAME )
                fclose(FID);
                disp(sprintf('File parsing error (frame): %s',FileName));
                D = [ ];
                R = false;
                V = { };
                return;
            end

            FrameSize = fread(FID,2,'int')';

            if( feof(FID) )
                fclose(FID);
                disp(sprintf('Unexpected end of file (frame): %s',FileName));
                D = [ ];
                R = false;
                V = { };
                return;
            end

            FrameData = zeros(FrameSize);

            FrameLinear = fread(FID,FrameSize(1) * FrameSize(2),'double');

            s = 1;
            e = FrameSize(2);

            for r=1:FrameSize(1)
                FrameData(r,:) = FrameLinear(s:e);
                s = s + FrameSize(2);
                e = e + FrameSize(2);
            end

            eval(sprintf('D.%s.Frames(%d) = FrameSize(1);',FrameName{f},Trial));

            for v=1:FrameVariables(f)
                if( FrameVariableDim(f,v,1) == 1 )
                    eval(sprintf('D.%s.%s(%d,1:%d,1:%d) = FrameData(:,%d:%d);',FrameName{f},FrameVariableName{f,v},Trial,FrameSize(1),FrameVariableItems(f,v),FrameVariableColumn(f,v),(FrameVariableColumn(f,v)+FrameVariableItems(f,v)-1)));
                else
                    items = FrameVariableDim(f,v,2) * FrameVariableDim(f,v,3);
                    for i=1:FrameVariableDim(f,v,1)
                        offset = ((i-1) * items);
                        eval(sprintf('D.%s.%s(%d,1:%d,%d,1:%d) = FrameData(:,%d:%d);',FrameName{f},FrameVariableName{f,v},Trial,FrameSize(1),i,items,FrameVariableColumn(f,v)+offset,(FrameVariableColumn(f,v)+offset+items-1)));
                    end
                end
            end

            clear FrameLinear FrameData FrameSize;

            % Current position in file and percent complete.
            FilePosition = ftell(FID);
            PercentComplete = (FilePosition / FileSize) * 100.0;
        end
    end    
end

R = true; % Success

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close file.                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fclose(FID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
