function [score,pass] = objectTuningScore(posArray,spikeArray,objectPosArray)
%objectTuningScore.m 
%   General comments:
%   - This function calculates object-tuning scores through an iterative
%   template-matching procedure as done in "Object-centered population
%   coding in CA1 of the hippocampus" by Nagelhus et al. 2023. 
%
%   Inputs:
%   <posArray>, <spikeArray> and <objectPosArray> should all be 1x2 cell
%   arrays. The cell array's first entry should contain data from the
%   Object trial; the second entry data from the Object Moved trial. 
%   Each entry of <posArray> should be a Tx3 matrix of position data. The
%   matrix should consist of timestamps (column 1), x-coordinates of the
%   animal's position (column 2) and y-coordinates of the animal's position
%   (column 3). T is the number of samples in the position data. 
%   Each entry of spikeArray should be a Nx1 vector of spike timestamps. 
%
%   Outputs: <score>, cell's object-tuning score
%            <pass>, logical variable whether the cell passed or not
%            ("true" and "false", respectively). 

%calculate rate map + bin edges from position- and spike data 
[rateMapArray,edgesX_array,edgesY_array]=rateMapData(posArray,spikeArray);

%calculate template-matching scores  
[objectScoreMatrix]=templateMatchingScore(rateMapArray,edgesX_array,edgesY_array,objectPosArray);

%calculate object-tuning scores (as minimum of correlations from Object and
%Object Moved trials)
scoreMatrix=min(objectScoreMatrix,[],4);

%calculate template-matching scores when shuffling object position
shuffledData=shuffledTemplateMatchingScore(rateMapArray,edgesX_array,edgesY_array);

%get 99th percentile thresholds from shuffled data 
percentile=99;
shuffledThresholds=prctile(min(shuffledData,[],3),percentile);

%compare actual template matching scores to shuffled data 
[score,pass]=compareThreshold(scoreMatrix,shuffledThresholds);



end

