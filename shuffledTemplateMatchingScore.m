function shuffledData=shuffledTemplateMatchingScore(rateMapArray,edgesX_array,edgesY_array)
%UNTITLED23 Summary of this function goes here
%   Detailed explanation goes here

%define standard deviations
binSize=3;
SD_cm=[5,10,25,50,75,100,150,200];
SD=SD_cm./binSize;
numSigma=length(SD);

numConditions=2; 


numPermutations=500;


shuffledData=zeros(numPermutations,numSigma,numConditions);


a=0;
b=150;
numDraws=1;



for s=1:numSigma
    
    currentSigma=SD(s);
    
    
    %corrVals=zeros(numPermutations,numConditions);
    
    
    
    for sh=1:numPermutations
        
        
        %shuffled object coordinates
        shuffledObjectPos=a+(b-a)*rand(numDraws,2);
        
        
        for f=1:numConditions
            
            
            currentMap=rateMapArray{f};
            currentEdges_X=edgesX_array{f};
            currentEdges_Y=edgesY_array{f};
            
            
            rho=objectScore(currentMap,currentEdges_X,currentEdges_Y,shuffledObjectPos,currentSigma);
            
            shuffledData(sh,s,f)=rho;
            
            %corrVals(sh,f)=rho;
            
            
        end
        
    end
    
    %shuffledData{k,s}=corrVals;
    
    
end




end