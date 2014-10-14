function [D,R] = DATAFILE_Read(FileName,Trial0,Trial1,FrameDataFlag)
% Reads experimental data for trials from a file.
%   [D,R] = DATAFILE_Read(FileName,TrailFirst,TrialLast,FrameDataFlag)
%   [D,R] = DATAFILE_Read(FileName,TrailFirst,TrialLast)
%   [D,R] = DATAFILE_Read(FileName,TrailMax)
%   [D,R] = DATAFILE_Read(FileName)
%   D = Data
%   R = Return code (Boolean success)

if( nargin < 4 )
    FrameDataFlag = true;
end

if( nargin == 1 )
    Trial0 = 0;
    Trial1 = 0;
elseif( nargin == 2 )
    Trial1 = Trial0;
    Trial0 = 1;
end

% Data types.
DATAFILE_HEADER = 72;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open file.                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FID = fopen(FileName,'r');

if( FID == -1 )
    errstr = sprintf('Cannot open file: %s',FileName);
    if( nargout == 1 )
        error(errstr);
    else
        disp(errstr);
        D = [ ]; R = 0;
        return;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read version number for data file                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DataType = fread(FID,1,'uchar');

if( DataType ~= DATAFILE_HEADER )
    fclose(FID);
    errstr = sprintf('File parsing error (header): %s',FileName);
    if( nargout == 1 )
        error(errstr);
    else
        disp(errstr);
        D = [ ]; R = 0;
        return;
    end
end

VersionNumber = fread(FID,1,'uint8');

% Hack version number.
if( VersionNumber > 5 )
    VersionNumber = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close file.                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fclose(FID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read data file with version-appropriate function.      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch( nargout )
    case 1
        eval(sprintf('D = DATAFILE_Read%d(FileName,Trial0,Trial1,FrameDataFlag);',VersionNumber));
    case 2
        eval(sprintf('[D,R] = DATAFILE_Read%d(FileName,Trial0,Trial1,FrameDataFlag);',VersionNumber));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
