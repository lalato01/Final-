function [orgCpp,cppData,secShifts,subjs,numSubjs] = importingData(rawCppData)
%% Help Documentation importingData
% The function importingData obtains the raw cpp data and creates a struct that will
% contain matrices further data storage and processing. It takes for an input the filename
% and returns the struct orgCpp, the raw data format in a cell array table, the number
% of sector shifts, and subjects.

%% Importing data & creating struct
% Name of xls sheet currently being analyzed
orgCpp.xlsName = rawCppData;
% Select range of data
if orgCpp.xlsName == '_CPP Piloting Trial 1.xlsx'
    rawData = 'E1:AJ37';
else
    rawData = 'E1:R28';
end
% Obtain all raw data from file
[~, ~, cppData] = xlsread(rawCppData,'CPP Format',rawData);

cppData(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),cppData)) = {''};

% Create ouput argument as a struct, with first field containing subject ID's
orgCpp.animalID = cppData(1,:)';
orgCpp.animalID(cellfun('isempty', orgCpp.animalID)) = [];

% Make matrices for each compartment with the corresponding dimensions
cppData(1,:)=[]; % Delete first row after animal ID's have been stored
[secShifts,subjs] = size(cppData);
numSubjs = subjs/2;
orgCpp.sectorMtxs = NaN(secShifts,numSubjs,2);

% Each column will correspond to one subject and the rows in that column to the amount of compartment shifts.
% Each cell contains the duration, in seconds, that the animal spent in that compartment before switching.

