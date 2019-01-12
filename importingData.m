function orgCpp = importingData(rawCppData)
%% Help Documentation importingData
% The function importingData obtains the raw cpp data and creates a struct that will
% contain matrices for further data storage and processing. 

% INPUTS 
% Filename 
% e.g. rawCppData = 'xxx.xlsx' 
% This is determined from the previous script. 

% OUPUT 
% Struct: orgCpp
% This struct includes the filename, the raw data formatted in a cell array table, the animal ID's, the number
% of animals, and preallocates matrices that will contain the duration of sector shifts for each animal.

%% Importing data & creating struct

% Name of xls sheet currently being analyzed
orgCpp.xlsName = rawCppData;
% Select range of data
if strcmpi('_CPP Piloting Trial 1.xlsx',orgCpp.xlsName) == 1 % Case insensitive comparison
    rawData = 'E1:AJ37';
else
    rawData = 'E1:R28';
end
% Obtain all raw data from file
[~, ~, orgCpp.cppRawData] = xlsread(rawCppData,'CPP Format',rawData);

orgCpp.cppRawData(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),orgCpp.cppRawData)) = {''};

% Create ouput argument as a struct, with first field containing subject ID's
orgCpp.animalID = orgCpp.cppRawData(1,:)';
orgCpp.animalID(cellfun('isempty', orgCpp.animalID)) = [];

% Make matrices for each compartment with the corresponding dimensions
orgCpp.cppRawData(1,:)=[]; % Delete first row after animal ID's have been stored
[secShifts,subjs] = size(orgCpp.cppRawData);
orgCpp.numSubjs = subjs/2;
orgCpp.sectorMtxs = NaN(secShifts,orgCpp.numSubjs,2);

% Each column will correspond to one subject and the rows in that column to the amount of compartment shifts.
% Each cell contains the duration, in seconds, that the animal spent in that compartment before switching.

orgCpp = storingDurs(orgCpp,orgCpp.cppRawData,secShifts,subjs); % Store duration data

function orgCpp = storingDurs(orgCpp,cppData,secShifts,subjs)
%% Help Documentation storingDurs
% The function storingDurs steps through the cell array table with the raw data format,
% converts all the durations to seconds and stores them in separate matrices
% representing the compartments (pink versus blue). 

% INPUT
% Variables from the importingData function (orgCpp: struct,cppData: raw data, 
% secShifts: number of sector shifts, and subjs: number of subjects)

% OUTPUT 
% Updated struct (orgCpp) 

%% Extracting and storing durations (in seconds) into corresponding matrices
row = 1;
col = 1;
pinkMtxRow = 1;
blueMtxRow = 1;
pinkMtxCol = 1;
blueMtxCol = 1;
% while not at the end of the datasheet
while row <= secShifts && col <= subjs
    % If the next row is either numeric or empty, start at the top of the
    % next column & set corresponding position for storing in appropriate matrix
    if isnumeric(cppData{row,col}) || isempty(cppData{row,col})
        col = col+1;
        row = 1;
        if col > subjs % Break if you've reached the end of the xls
            break
        end
        if pinkMtxRow ~= 1
            pinkMtxCol = pinkMtxCol + 1;
            pinkMtxRow = 1;
            blueMtxRow = 1;
        elseif blueMtxRow ~= 1
            blueMtxCol = blueMtxCol + 1;
            pinkMtxRow = 1;
            blueMtxRow = 1;
        end
    end
    cellElems = strsplit(cppData{row,col},{' ','-','.'}); % Parse element data
    cellElems{2} = str2double(cellElems{2}); % Convert duration to a number
    if numel(cellElems) ~= 2
        if cellElems{3} == ' ' % Error handling: if there's an extra space
            mins2secs = cellElems{2};
        else
            cellElems{3} = str2double(cellElems{3});
            mins2secs = (cellElems{2} * 60) + cellElems{3};  % If the duration is in minutes, convert to seconds
        end
    else
        mins2secs = cellElems{2}; % Otherwise, keep the seconds
    end
    if strcmpi('P',cellElems{1}) == 1 % Case insensitive comparison of sector duration to be stored
        % Store durations in appropriate matrix (1st dimension = pinkMtx), with corresponding row and column
        orgCpp.sectorMtxs(pinkMtxRow,pinkMtxCol,1) = mins2secs;
        pinkMtxRow = pinkMtxRow + 1;
    else % If cellElems{1} is a 'B'
        % Store durations in appropriate matrix (2nd dimension = blueMtx), with corresponding row and column
        orgCpp.sectorMtxs(blueMtxRow,blueMtxCol,2) = mins2secs;
        blueMtxRow = blueMtxRow + 1;
    end
    row = row+1;
    % Continue to loop until the end of cppData
end

% State machine status

