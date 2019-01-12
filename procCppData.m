%% Help Documentation procCppData
<<<<<<< HEAD
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

=======
% The script procCppData takes for an input an excel sheet with stored
% raw data (from conditioned place preference experiments- CPP) for further processing
% (i.e. processed cpp data). It can also analyze more than one excel sheet and will indicate
% which sheet is currently being analyzed.
% The ouput is a struct with several fields containing the animal ID's,
% matrices with the durations for a specific sector for all animals, the
% summation of each animal's durations, as well as their percentages.
% Lastly, it contains a field with the final percentage, and afterwards
% indicates what the cohort compartment preference was.
% orgCpp =
%   xlsName: '.xlsx'
%   animalID:xxx
%   sectorMtxs:xxx
%   MtxsColSums:xxx
%   indvTotalDur:xxx
%   indvPref:xxx
%   grpSectorPref:xxx
% Pink cohort preference: xx%
% Blue cohort preference: xx%

>>>>>>> 66adf2bad35ee6f8612dd2f32a2bd85ca8a620b8
%% Main Script
% Obtain all files named 'CPP Piloting'
rawCppDataAll = dir('_CPP Piloting*.xlsx');
if isempty(rawCppDataAll)
    error('No excel data spreadsheets found')
end
<<<<<<< HEAD

xlsSheets = size(rawCppDataAll,1);
for excels = 1:xlsSheets
    rawCppData = rawCppDataAll(excels).name; % Get name of file
    fprintf('\n%s\n\n',rawCppData);
    orgCpp(excels) = importingData(rawCppData); % Obtain data from file
    analyzedCpp(excels) = dataAnalysis(orgCpp(excels)); % Analyze CPP data
end

=======
xlsSheets = length(rawCppDataAll); 
for excels = 1:xlsSheets
    rawCppData = rawCppDataAll(excels).name; % Get name of file
    [orgCpp,cppData,secShifts,subjs,numSubjs]  = importingData(rawCppData); % Obtain data from file
    orgCpp = storingDurs(orgCpp,cppData,secShifts,subjs); % Store duration data
    orgCpp = dataAnalysis(orgCpp,numSubjs); % Analyze CPP data
    % Journal of Neuroscience Figure
    subplot(xlsSheets,1,excels) % https://www.mathworks.com/help/matlab/ref/figure.html
    iterations = length(orgCpp.indvPref);
    steps = 1:iterations;
    figOrder = [orgCpp.indvPref(1,steps,1);orgCpp.indvPref(1,steps,2)]';
    figHandle = bar(figOrder,'stacked');
    set(figHandle(:,1),'facecolor','m');
    set(figHandle(:,2),'facecolor','c');
end

%% JNeuro Fig Requirements (tbd...) 
% fH.PaperUnits = 'centimeters'
% fH.PaperPosition = [0 0 16 8]% check the web
% https://www.mathworks.com/help/matlab/ref/bar.html
% a = 'Arial';
% b = 10;
% xlabel('pref','fontSize',b,'fontName',a)
>>>>>>> 66adf2bad35ee6f8612dd2f32a2bd85ca8a620b8
