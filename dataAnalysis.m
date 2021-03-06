<<<<<<< HEAD
function analyzedCpp = dataAnalysis(orgCpp)
%% Help Documentation dataAnalysis
% The function dataAnalysis computes the results for cpp data experiments.

% INPUT 
% Previous struct (orgCpp) 
% It takes for an input the output variables from the importingData and

% OUTPUT 
% Struct: analyzedCpp 
% This struct contains all the information regarding the computations performed on the data.
% Function will indicate what the cohort compartment preference was
% e.g.
% Pink cohort preference: xx.xx%
% Blue cohort preference: xx.xx%

%% Data Analysis

% Sum the durations of each animal
analyzedCpp.MtxsColSums = nansum(orgCpp.sectorMtxs);
% Total duration per animal
indvSubjDur = 1:1:orgCpp.numSubjs;
analyzedCpp.indvTotalDur = analyzedCpp.MtxsColSums(1,indvSubjDur,1) + analyzedCpp.MtxsColSums(1,indvSubjDur,2); % sum of corresponding pinkMtxColSums + blueMtxColSums
% Indv animal compartment percentage
analyzedCpp.indvPref = ((analyzedCpp.MtxsColSums./analyzedCpp.indvTotalDur).*100);
% Get cohort pink vs. blue preference
analyzedCpp.grpSectorPref =((sum(analyzedCpp.MtxsColSums))./(sum(analyzedCpp.indvTotalDur))).*100;

% Sanity check: all fields created above need to equal the amount of subjects
if length(orgCpp.animalID) ~= orgCpp.numSubjs && length(analyzedCpp.MtxsColSums) ~= orgCpp.numSubjs && length(analyzedCpp.indvTotalDur) ~= orgCpp.numSubjs && length(analyzedCpp.indvPref) ~= orgCpp.numSubjs
    warning('Vector elements vary in length: durations not properly obtained')
end
fprintf('Pink cohort preference: %.2f%% \nBlue cohort preference: %.2f%%\n\n', analyzedCpp.grpSectorPref(:,:,1), analyzedCpp.grpSectorPref(:,:,2));

%% Journal of Neuroscience Figure

imgTitle = erase(orgCpp.xlsName,["_",".xlsx"]);
graphOption = questdlg(['Would you like to graph ', imgTitle, ' individual preferences?'], 'Graph', 'Yes', 'No','Yes');

if strcmpi(graphOption, 'Yes')
    cppFig = figure; % https://www.mathworks.com/help/matlab/ref/figure.html
    iterations = length(analyzedCpp.indvPref);
    steps = 1:iterations;
    figOrder = [analyzedCpp.indvPref(1,steps,1);analyzedCpp.indvPref(1,steps,2)]';
    figHandle = bar(figOrder,'stacked'); % https://www.mathworks.com/help/matlab/ref/bar.html
    set(figHandle(:,1),'facecolor','m');
    set(figHandle(:,2),'facecolor','c');
    imgHandle = gcf; 
    imgHandle.PaperUnits = 'centimeters';
    imgHandle.PaperPosition = [0 0 17.6 10];
    box off; 
    title(imgTitle);
    legend('Pink Sector','Blue Sector', 'location', 'northeastoutside'); 
    ax = gca;
    ax.XTick = 1:orgCpp.numSubjs; 
    ax.XLabel.String = 'Number of Animals'; 
    ax.YLabel.String = 'Percentage'; 
    print(cppFig,imgTitle,'-dtiff','-r300');
else
    return;
end
=======
function [orgCpp,indvSubjDur] = dataAnalysis(orgCpp,numSubjs)
%% Help Documentation dataAnalysis
% The function dataAnalysis computes the results for cpp data experiments.
% It takes for an input the output variables from the importingData and storingDurs functions 
% and returns as an output the finalized struct with all the information regarding the 
% computations done on the data. It also outputs the final cohort compartment preferences. 

%% Data Analysis
% This will be made into an image matching JNeurosci formatting requirements
% Sum the durations of each animal
orgCpp.MtxsColSums = nansum(orgCpp.sectorMtxs);
% Total duration per animal
indvSubjDur = 1:1:numSubjs;
orgCpp.indvTotalDur = orgCpp.MtxsColSums(1,indvSubjDur,1) + orgCpp.MtxsColSums(1,indvSubjDur,2); % sum of corresponding pinkMtxColSums + blueMtxColSums
% Indv animal compartment percentage
orgCpp.indvPref = ((orgCpp.MtxsColSums./orgCpp.indvTotalDur).*100);
% Get cohort pink vs. blue preference
orgCpp.grpSectorPref =((sum(orgCpp.MtxsColSums))./(sum(orgCpp.indvTotalDur))).*100;

% Sanity check: all fields created above need to equal the amount of subjects
if length(orgCpp.animalID) ~= numSubjs && length(orgCpp.MtxsColSums) ~= numSubjs && length(orgCpp.indvTotalDur) ~= numSubjs && length(orgCpp.indvPref) ~= numSubjs
    warning('Vector elements vary in length: durations not properly obtained')
end
orgCpp % Final struct and fields 
fprintf('Pink cohort preference: %.2f%% \nBlue cohort preference: %.2f%%\n\n', orgCpp.grpSectorPref(:,:,1), orgCpp.grpSectorPref(:,:,2))
>>>>>>> 66adf2bad35ee6f8612dd2f32a2bd85ca8a620b8

