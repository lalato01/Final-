function orgCpp = procCppData(cppData)
%% Help Documentation procCppData
% The function procCppData takes for an input an excel sheet with stored
% raw data (from conditioned place preference experiments- CPP) for further processing.
% The ouput is a struct with several fields containing the animal ID's,
% matrices with the durations for a specific sector for each animal, and the
% summation of each animal's durations, as well as their percentage.
% Lastly, it contains a field with the final percentage, indicating what the cohort compartment preference was.
% E.g. cppData = '_CPP Piloting Trial 1.xlsx'
% orgCpp =
%   animalID:xxx
%   pinkMtx:xxx
%   blueMtx:xxx
%   pinkMtxColSums:xxx
%   blueMtxColSums:xxx
%   indvTotalDur:xxx
%   indvPinkPref:xxx
%   indvBluePref:xxx
%   grpPinkPref:xxx
%   grpBluePref:xxx

%% Importing data & Creating Struct 
% Select range of data
rawData = 'E1:AJ37';

% Obtain all raw data from file
[~, ~, cppData] = xlsread(cppData,'CPP Format',rawData);
cppData(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),cppData)) = {''};

% Create ouput argument as a struct, with first field containing subject ID's
orgCpp.animalID = cppData(1,:)';
orgCpp.animalID(cellfun('isempty', orgCpp.animalID)) = [];

% Make matrices for each compartment with the corresponding dimensions
cppData(1,:)=[]; % Delete first row after animal ID's have been stored 
[secShifts,subjs] = size(cppData);
orgCpp.sectorMtxs = NaN(secShifts,(subjs/2),2);

% Each column will correspond to one subject and the rows in that column to the amount of compartment shifts.
% Each cell contains the duration, in seconds, that the animal spent in that compartment before switching.

%% Extracting and storing durations(s) into corresponding matrices 
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
        if cellElems{3} == ' ' % Error handling- if there's an extra space
            mins2secs = cellElems{2};
        else
            cellElems{3} = str2double(cellElems{3});
            mins2secs = (cellElems{2} * 60) + cellElems{3};  % If the duration is in minutes, convert to seconds
        end
    else
        mins2secs = cellElems{2}; % Otherwise, keep the seconds
    end
    if cellElems{1} == 'P'
        % Store durations in appropriate matrix (1st dimension = pinkMtx), with corresponding row and column
        orgCpp.sectorMtxs(pinkMtxRow,pinkMtxCol,1) = mins2secs;
        pinkMtxRow = pinkMtxRow + 1;
    else
        cellElems{1} == 'B';
        % Store durations in appropriate matrix (2nd dimension = blueMtx), with corresponding row and column
        orgCpp.sectorMtxs(blueMtxRow,blueMtxCol,2) = mins2secs;
        blueMtxRow = blueMtxRow + 1;
    end
    row = row+1;
    % Continue to loop until the end of cppData
end
%%
% % This will be made into an image matching JNeurosci formatting requirements
% % In matrix P and B sum the durations of each animal, get total duration per animal, and indv animal compartment percentage
orgCpp.MtxsColSums = sum(orgCpp.sectorMtxs,'omitnan');
indvSubj = 1; 
indvSubjDur = 1:indvSubj:(subjs/2);
orgCpp.indvTotalDur = orgCpp.MtxsColSums(indvSubj,indvSubjDur,1) + orgCpp.MtxsColSums(indvSubj,indvSubjDur,2); 

% orgCpp.pinkMtxColSums = sum(column-wise addition of col durations: pinkMtx,'omitnan');
% orgCpp.blueMtxColSums = sum(column-wise addition of col durations: blueMtx,'omitnan');
% orgCpp.indvTotalDur = sum of corresponding pinkMtxColSums + blueMtxColSums;
% orgCpp.indvPinkPref = corresponding (pinkMtxColSums./indvTotalDur)*100;
% orgCpp.indvBluePref = corresponding (pinkMtxColSums./indvTotalDur)*100;
% % Sanity check: all new fields created above need to equal the amount of subjects
% if length(indvPink & BluePref) ~= length(indvTotalDur) ~= length(pink & blueMtxColSums) ~= length(pinkMtx)
%     warning('Vector elements vary in length: durations not properly obtained')
% end
%
% % Get cohort pink vs. blue preference
% orgCpp.grpPinkPref = ((sum(orgCpp.pinkMtxColSums))/(sum(orgCpp.indvTotalDur)))*100;
% orgCpp.grpBluePref = ((sum(orgCpp.blueMtxColSums))/(sum(orgCpp.indvTotalDur)))*100;
