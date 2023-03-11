function [outputArg1,outputArg2] = distanceSet(inputArg1,inputArg2)
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here



%distanceSet=cell(numDistanceBins,numConditions);

for g=1:numConditions
    
    distanceMap=collectDistanceMaps{1,g};  

for b=1:numDistanceBins 
    
    
    logicalMap=distanceMap>distanceEdges{g}(b) & distanceMap<distanceEdges{g}(b+1);
    
    [r,c]=find(logicalMap); 
    
    distanceSet{b,g}=[r,c]; 
        
    
end 
    

end 














end

