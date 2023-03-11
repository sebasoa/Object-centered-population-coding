function [objectScoreMatrix]=templateMatchingScore(rateMapArray,edgesX_array,edgesY_array,objectPosArray)
%templateMatchingScore.m 
%   


%%% Iterate over different sigma and template locations


%define standard deviations of Gaussian template to iterate over
binSize=3;
SD_cm=[5,10,25,50,75,100,150,200];
SD=SD_cm./binSize;
numSigma=length(SD);

%define radial shifts of template to iterate over
radii=[0,5,10,15,20,30,40,50,60];
numRadii=length(radii);
angles=0:pi/4:2*pi;
angles(end)=[];
numAngles=length(angles);

numConditions=2; 

objectScoreMatrix=NaN(numAngles,numRadii,numSigma,numConditions);


for s=1:numSigma
    
    currentSigma=SD(s);
    
    %prepare using NaNs
    corrVals=NaN(numAngles,numRadii,numConditions);
    
    %experimentInd=spikeData.empty(k).experimentInd;
    
    
    for f=1:numConditions
        
        
        currentMap=rateMapArray{f};
        currentEdges_X=edgesX_array{f};
        currentEdges_Y=edgesY_array{f};
        
        
        currentObjectPos=objectPosArray{f};
        x=currentObjectPos(1);
        y=currentObjectPos(2);
        
        
        for r=1:numRadii
            
            radius=radii(r);
            
            if radius==0
                templateCoord=[x,y];
            else
                templateCoord=[x+(radius*cos(angles));y+(radius*sin(angles))]';
            end
            
            numTemplates=size(templateCoord,1);
            
            
            for a=1:numTemplates
                
                shiftedTemplate=templateCoord(a,:);
                
                rho=objectScore(currentMap,currentEdges_X,currentEdges_Y,shiftedTemplate,currentSigma);
                
                corrVals(a,r,f)=rho;
                
                objectScoreMatrix(a,r,s,f)=rho;
                
                
            end
            
            
        end
        
        
        
    end
    
      
    
    
end






end