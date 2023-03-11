function [distanceMap] = calculateDistanceMap(xVals,yVals,objectPos)
%calculateDistanceMap.m 
%   Detailed explanation goes here

numBins_X=length(xVals);
numBins_Y=length(yVals);

distanceMap=zeros(numBins_Y,numBins_X); 

for i=1:numBins_Y
    
    for j=1:numBins_X
        
        difference=[xVals(j),yVals(i)]-objectPos;
        distance=sqrt(sum(difference.^2,2));
        distanceMap(i,j)=distance;
        
    end
    
end 
        
        


end

