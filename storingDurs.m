function orgCpp = storingDurs(orgCpp,cppData,secShifts,subjs)
%% Help Documentation storingDur
% The function storingDur steps through the cell array table with the raw data format,
% converts the durations all to seconds and stores them
% in separate matrices representing the compartments (pink versus blue). It takes for an input
% the output variables from the importingData function and returns as an output the struct
% orgCpp with the new stored values.

%% Extracting and storing durations (s) into corresponding matrices
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

% State machine status

