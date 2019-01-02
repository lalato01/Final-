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

