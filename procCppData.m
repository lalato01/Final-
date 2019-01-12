%% Help Documentation procCppData
% The script procCppData takes raw data (from conditioned place preference experiments- CPP) 
% for further processing (i.e. processed cpp data), and returns the percentage the cohort spent
% in one compartment versus the other. If chosen, it can also generate a graph.

% INPUTS 
% Script name 
% e.g. procCppData 

% OUTPUT
% Script will indicate what the cohort compartment preference was
% e.g.
% Pink cohort preference: xx.xx%
% Blue cohort preference: xx.xx%

%% Main Script
% Obtain all files named 'CPP Piloting'
rawCppDataAll = dir('_CPP Piloting*.xlsx');
if isempty(rawCppDataAll)
    error('No excel data spreadsheets found')
end

xlsSheets = size(rawCppDataAll,1);
for excels = 1:xlsSheets
    rawCppData = rawCppDataAll(excels).name; % Get name of file
    fprintf('\n%s\n\n',rawCppData);
    orgCpp(excels) = importingData(rawCppData); % Obtain data from file
    analyzedCpp(excels) = dataAnalysis(orgCpp(excels)); % Analyze CPP data
end

