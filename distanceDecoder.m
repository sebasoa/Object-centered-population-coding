function [accuracy] = distanceDecoder(posArray,spikeArray,objectPos)
%distanceDecoder.m 
%
%  General comments: 
%  - This function performs the distance decoding as done in
%  "Object-centered population coding in CA1 of the hippocampus" by
%  Nagelhus et al. 2023 (for example, to generate results in Figure 4b, c).
%  - To perform the analysis, it is necessary to provide spike and
%  position- data from two conditions (Empty vs. Object, or similar).
%  Instructions are given below. 
%
%  Inputs:
%  <posArray>, should be a 1x2 cell array, where each entry contains
%  position data from the empty trial and the object trial. Position data
%  itself should be a Tx3 matrix, where T is the number of timestamps.
%  First column of position data should contain timestamps; second column should contain the x
%  coordinates of the animal's position; third column should contain the y
%  coordinates. 
%
%  <spikeArray>, should be an Nx2 cell array, where N is the number of
%  neurons recorded in the empty and object trials. Each entry of the cell
%  array should be an Sx1 matrix of spike timestamps. 
%
% <objectPos>, 1x2 vector of object coordinates (x, y)
%
%  Outputs: 1x5 vector of decoding accuracies in different distance bins 
%





%parameters 
numPermutations=2;
conditions={'empty','object'}; 
numConditions=length(conditions); 
numDistanceBins=5; 
numCells=size(spikeArray,1); 

%this variable stores results of distance decoder
outcome=cell(numDistanceBins,numConditions);
outcome(:)={cell(1,numPermutations)}; 


%2 permutations (one using first half of data for testing; the other
%using second half of data for testing)

for q=1:numPermutations
    
    if q==1
        isFirstHalfTesting=true;
    elseif q==2
        isFirstHalfTesting=false; 
    end 

    
    disp(['Current permutation is ',num2str(q)]);
    
%% Divide position- and spike data into training/testing


for g=1:numConditions
    
    pos=posArray{g}; 
    
    [posTraining,posTesting,separationPoint]=divideTrainingTesting(pos,isFirstHalfTesting); 
       
    posDataTesting.(conditions{g}).pos=posTesting; 
    posDataTraining.(conditions{g}).pos=posTraining; 
    
    for k=1:numCells
        
        spikes=spikeArray{k,g};
        [spikesTraining,spikesTesting]=divideTrainingTesting(spikes,isFirstHalfTesting,separationPoint); 
        
        spikeDataTesting.(conditions{g})(k).spikes=spikesTesting; 
        spikeDataTraining.(conditions{g})(k).spikes=spikesTraining; 
        
    end 
    
    
end 
    

%% Rate maps


%Calculate rate maps, occupancy maps and "distance maps" (distance map
%contains distance to object at every position)


collectRateMaps=cell(numCells,numConditions);
collectOccupancyMaps=cell(1,numConditions);
collectDistanceMaps=cell(1,numConditions); 



for g=1:numConditions
    
    pos=posDataTraining.(conditions{g}).pos;
    
    STOP=false; 
        
for k=1:numCells
    
    spikes=spikeDataTraining.(conditions{g})(k).spikes;
    
    %calculate structure with all information for rate maps
    map=calculateRateMap(pos,spikes(:,1),'smooth',2,'blanks','off','binWidth',3); 
    
    %rate map
    collectRateMaps{k,g}=map.z; 
    
    
    if STOP==false && ~isempty(spikes)
        
        
        % Calculate occupancy map and distance map
        
        %occupancy map
        collectOccupancyMaps{1,g}=map.time;
        
        %x- and y edges of rate map are necessary inputs for distance map
        xVals=calculateBinCentres(map.x); 
        yVals=calculateBinCentres(map.y); 
        
        %distance map
        distanceMap=calculateDistanceMap(xVals,yVals,objectPos); 
        collectDistanceMaps{1,g}=distanceMap; 
                
                STOP=true;    
        
    end
    
       
 
     
end

end 




%% Binning spike matrix


%calculate spike matrices from testing data

spikeMatrix_full=cell(1,numConditions);
binTimes=cell(1,numConditions); 

%timescale of decoder
binSize_sec=1; 


for g=1:numConditions

pos=posDataTesting.(conditions{g}).pos;

[spikeMatrix_full{g},binTimes{g}]=binningSpikeMatrix(pos,spikeDataTesting.(conditions{g}),binSize_sec); 


end



%% Equal distance binning

%This ensures we have the same number of testing samples in each distance bin 


spikeMatrix=cell(numDistanceBins,numConditions); 
distanceEdges=cell(1,numConditions); 


for g=1:numConditions
    
    %get necessary inputs for distance binning (position data, spike matrix
    %and timestamps of spike matrix)
    pos=posDataTesting.(conditions{g}).pos;
    currentSpikeMatrix=spikeMatrix_full{g}; 
    timestamps=binTimes{g}'; 
    
    %equal distance binning
    [spikeMatrix_equalBins,distanceEdges_equalBins]=equalDistanceEdges(pos,currentSpikeMatrix,timestamps,objectPos); 
    
    %store binned testing data and distance edges
    spikeMatrix(:,g)=spikeMatrix_equalBins;
    distanceEdges{g}=distanceEdges_equalBins; 
    

           
end



%% Calculate "distance sets" (which spatial bins of the rate map belongs to which distance bin)


distanceSet=cell(numDistanceBins,numConditions);

for g=1:numConditions
    
    distanceMap=collectDistanceMaps{1,g};  

for b=1:numDistanceBins 
    
    logicalMap=distanceMap>distanceEdges{g}(b) & distanceMap<distanceEdges{g}(b+1);
    
    [r,c]=find(logicalMap); 
    
    distanceSet{b,g}=[r,c]; 
        
    
end 
    

end 



%% Calculate priors


%prior based on animal's occupancy for both conditions (empty/object) and
%for all distance bins 

prior=cell(numDistanceBins,numConditions);

for g=1:numConditions
    
    currentOccupancyMap=collectOccupancyMaps{1,g};
    distanceMap=collectDistanceMaps{1,g};  

    for b=1:numDistanceBins
        
        logicalMap=distanceMap>distanceEdges{g}(b) & distanceMap<distanceEdges{g}(b+1);
        
        %occupancy map normalised to a probability distribution
        priorMat=currentOccupancyMap;
        priorMat(~logicalMap)=0;
        priorMat=priorMat./sum(priorMat(:)); 
        prior{b,g}=priorMat; 
        
        
    end
    
end 
        
        
      

%% Poisson-based rate model



%iterate over testing data from different conditions and distance bins

for c=1:numConditions
    
    disp(['Decoding testing data from condition ',num2str(c)]);
    
    for b=1:numDistanceBins
        
        disp(['Decoding testing data from distance bin ',num2str(b)]);
        
        %get necessary input for decoder
        currentSpikeMatrix=spikeMatrix{b,c};
        currentPrior=prior(b,:);
        currentDistanceSet=distanceSet(b,:);
        
        %run decoder
        logRatioVector=PoissonDecoder_distance(currentSpikeMatrix,collectRateMaps,currentPrior,currentDistanceSet);
        
        %store results of decoder 
        outcome{b,c}{q}=logRatioVector;
        
        
    end
    
end

end

        

                             
%% Calculate decoding accuracy across distance bins


accuracy=calculateDecodingAccuracy(outcome); 




end

