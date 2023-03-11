function [score,pass]=compareThreshold(scoreMatrix,shuffledThresholds)
%compareThreshold.m
%   


numSigma=size(shuffledThresholds,2); 

diffMatrix=nan(size(scoreMatrix)); 

for s=1:numSigma
    
    diffMatrix(:,:,s)=scoreMatrix(:,:,s)-shuffledThresholds(s); 
    
end 
    


pass=any(diffMatrix>0,1:3); 

maxDiff=max(diffMatrix(:)); 
maxLogical=diffMatrix==maxDiff; 
score=scoreMatrix(maxLogical); 

numScores=length(score);
if numScores>1
    score=score(1);
end




end 