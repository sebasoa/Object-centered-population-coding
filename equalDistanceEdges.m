function [spikeMatrix_equalBins,edges] =equalDistanceEdges(pos,spikeMatrix,timestamps,objectPos)
%equalDistanceEdges.m
%   Detailed explanation goes here



numEqualBins=5; 
spikeMatrix_equalBins=cell(numEqualBins,1); 

currentDistanceEdges=0; 

bin2PosInd=knnsearch(pos(:,1),timestamps); 
    
XY=pos(bin2PosInd,2:3);
vectorDistance=sqrt(sum(((XY-objectPos).^2),2));
    
[~,sortInd]=sort(vectorDistance,'ascend'); 

T=size(sortInd,1); 

remainder=rem(T,numEqualBins); 

sortIndBinned=reshape(sortInd(1:end-remainder),[],numEqualBins);


binIndices=zeros(size(vectorDistance)); 
    
    %[~,~,binIndices]=histcounts(vectorDistance{q,g},distanceEdges);
    
    
for b=1:numEqualBins
    binIndices(sortIndBinned(:,b))=b; 
end
    
    
leftOut=floor(binIndices)~=binIndices; 
binIndices(leftOut)=numEqualBins;     
    
    

for b=1:numEqualBins
    
    logicalBin=binIndices==b;
    spikeMatrix_equalBins{b,1}=spikeMatrix(:,logicalBin');  
    
    currentDistanceEdges=[currentDistanceEdges,max(vectorDistance(binIndices==b))];
      
   
end


edges=currentDistanceEdges; 

      
           
end



