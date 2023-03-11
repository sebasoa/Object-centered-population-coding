function [binCentres] = calculateBinCentres(edges)
%calculateBinCentres.m 
%   Detailed explanation goes here


numBins=length(edges)-1; 

binCentres=zeros(1,numBins); 

for i=1:numBins 
    
    binCentres(i)=mean([edges(i),edges(i+1)]);
    
end



end

