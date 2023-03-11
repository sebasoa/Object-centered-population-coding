function [accuracy] = calculateDecodingAccuracy(outcome)
%calculateDecodingAccuracy.m 
%   


numDistanceBins=size(outcome,1); 
numConditions=size(outcome,2); 
numPermutations=size(outcome{1},2); 

successes=zeros(numDistanceBins,1); 
failures=zeros(numDistanceBins,1); 


for b=1:numDistanceBins
    
succ=0;
fail=0; 

for g=1:numConditions
            
    for q=1:numPermutations
        
        
        if g==1
            succ=succ+sum(outcome{b,g}{q}>0); 
            fail=fail+sum(outcome{b,g}{q}<0);
        elseif g==2
            succ=succ+sum(outcome{b,g}{q}<0); 
            fail=fail+sum(outcome{b,g}{q}>0);
        end
        
        
    end 
    
end 
            
       

successes(b)=succ;
failures(b)=fail; 
    
end 



total=successes+failures;

accuracy=successes./total; 




end

