function [D,R] = DATAFILE_Read0(FileName,Trial0,Trial1,FrameDataFlag)
% Reads experimental data for trials from a file (Version 0).
%   [D,R] = DATAFILE_Read0(FileName,TrialMax)
%   D - Data
%   R - Return code (Boolean success)

if( nargin ~= 4 )
    error('Invalid number of input parameters.');
end

DATAFILE_HEADER = 72;
DATAFILE_TRIAL  = 84;
DATAFILE_FRAME  = 70;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open file and determines file size in bytes.           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FID = fopen(FileName,'r');

if( FID == -1 )
    error('Cannot open file: %s',FileName);
end

% Seek to end of file to determine file size.
if( fseek(FID,0,'eof') ~= 0 )
    fclose(FID);
    disp(sprintf('Cannot find end of file: %s',FileName));
    D = [ ]; R = 0;
    return;
    end
end

FileSize = ftell(FID);

% Rewind to start of file.
if( fseek(FID,0,'bof') ~= 0 )
    fclose(FID);
    disp(sprintf('Cannot find start of file: %s',FileName));
    D = [ ]; R = 0;
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read header information.                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DataType = fread(FID,1,'uchar');

if( DataType ~= DATAFILE_HEADER )
    fclose(FID);
    disp(sprintf('File parsing error (header): %s',FileName));
    D = [ ]; R = 0;
    return;
end

Data = fread(FID,2,'int');

TrialColumns = Data(1);
FrameBlocks = Data(2);

for FrameBlock=1:FrameBlocks
    FrameDimensions(FrameBlock,:) = fread(FID,2,'int');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read trial data and have a peek at frame data.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EOF = 0;
TrialInput = 0;
TrialOutput = 0;
FrameRows = zeros(FrameBlocks);

while( EOF == 0 )
    DataType = fread(FID,1,'uchar');
    
    if( feof(FID) )
        EOF = 1;
        continue;
    end
    
    if( DataType ~= DATAFILE_TRIAL )
        fclose(FID);
        disp(sprintf('File parsing error (trial): %s',FileName));
        D = [ ]; R = 0;
        return;
    end
    
    TrialInput = TrialInput + 1;
    TrialNumber = fread(FID,1,'int');
    
    if( TrialNumber ~= TrialInput )
        fclose(FID);
        disp(sprintf('Trial numbers out of sequence (Expected=%d, Read=%d): %s',TrialInput,TrialNumber,FileName));
        D = [ ]; R = 0;
        return;
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
    
    % Take a peek at frame data without reading it.
    for FrameBlock=1:FrameBlocks
        DataType = fread(FID,1,'uchar');
        
        if( DataType ~= DATAFILE_FRAME )
            fclose(FID);
            disp(sprintf('File parsing error (frame): %s',FileName));
            D = [ ]; R = 0;
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
            disp(sprintf('Unexpected end of file (frame): %s',FileName));
            D = [ ]; R = 0;
            return;
        end

        % Total number of bytes in this frame data.
        FrameBytes = FrameSize(1) * FrameSize(2) * 8;
        
        % Seek over frame data without reading it.
        if( fseek(FID,FrameBytes,'cof') ~= 0 )
            fclose(FID);
            disp(sprintf('Cannot seek to position in file: %s',FileName));
            D = [ ]; R = 0;
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

% Put trial data into output argument for function.
D.Trials = Trials;
D.TrialNumber = TrialList;
D.TrialData = TrialData;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Allocate frame data matrix.                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for FrameBlock=1:FrameBlocks
    eval(sprintf('FrameData%d = zeros([ Trials FrameRows(%d) FrameDimensions(%d,2)]);',FrameBlock,FrameBlock,FrameBlock));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop through each trial reading frame data.            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for Trial=1:Trials
    disp(sprintf('Trial %d / %d',Trial,Trials))
    
    if( fseek(FID,FrameDataPosition(Trial),'bof') ~= 0 )
        fclose(FID);
        disp(sprintf('Cannot seek to position in file: %s',FileName));
        D = [ ]; R = 0;
        return;
    end
    
    for FrameBlock=1:FrameBlocks
        FrameData = zeros([ FrameRows(FrameBlock) FrameDimensions(FrameBlock,2)]);
        
        DataType = fread(FID,1,'uchar');
        
        if( DataType ~= DATAFILE_FRAME )
            fclose(FID);
            disp(sprintf('File parsing error (frame): %s',FileName));
            D = [ ]; R = 0;
            return;
        end
        
        FrameSize = fread(FID,2,'int')';
        
        if( feof(FID) )
            fclose(FID);
            disp(sprintf('Unexpected end of file (frame): %s',FileName));
            D = [ ]; R = 0;
            return;
        end
        
        FrameLinear = fread(FID,FrameSize(1) * FrameSize(2),'double');
        
        s = 1;
        e = FrameSize(2);
        
        for r=1:FrameSize(1)
            FrameData(r,:) = FrameLinear(s:e);
            s = s + FrameSize(2);
            e = e + FrameSize(2);
        end
        
        eval(sprintf('FrameData%d(Trial,:,:) = FrameData;',FrameBlock));
        eval(sprintf('FrameSize%d(Trial,:,:) = FrameSize;',FrameBlock));

        clear FrameLinear FrameData FrameSize;
        
        % Current position in file and percent complete.
        FilePosition = ftell(FID);
        PercentComplete = (FilePosition / FileSize) * 100.0;
    end
end    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Put frame data into output arguments for function.     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for f=1:FrameBlocks
    eval(sprintf('D.FrameData%d.Size = FrameSize%d;',f,f));
    eval(sprintf('D.FrameData%d.Data = FrameData%d;',f,f));
end

if( nargout >= 2 )
    R = 1; % Success
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close file and we're done.                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fclose(FID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

