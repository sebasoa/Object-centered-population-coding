function [trainingData,testingData,separationPoint] = divideTrainingTesting(data,isFirstHalfTesting,separationPoint)
%divideTrainingTesting.m 
%   Detailed explanation goes here


%if point of separation is not provided, use mipoint of data
if ~exist('separationPoint','var')
    
    dataStart=data(1,1);
    dataEnd=data(end,1);
    
    dataDuration=dataEnd-dataStart;
    testingDuration=(1/2)*dataDuration;
    
    separationPoint=dataStart+testingDuration;
    
end


%decide whether to use first or second half as testing data 
if isFirstHalfTesting==true
    testingLogical=data(:,1)<separationPoint;
elseif isFirstHalfTesting==false
    testingLogical=data(:,1)>separationPoint;
end


trainingLogical=~testingLogical; 

trainingData=data(trainingLogical,:);
testingData=data(testingLogical,:); 




end

