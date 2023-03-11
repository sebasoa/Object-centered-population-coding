function [spikeMatrix,binTimes] = binningSpikeMatrix(pos,spikeData,binSize_sec)
%binningSpikeMatrix.m 
%   Detailed explanation goes here



posStart=pos(1,1);
posEnd=pos(end,1);

edges=posStart:binSize_sec:posEnd; 

T=length(edges)-1; 
numCells=length(spikeData); 

spikeMatrix=zeros(numCells,T);


for k=1:numCells
    spikes=spikeData(k).spikes;
    spikeCounts=histcounts(spikes,edges);
    spikeMatrix(k,:)=spikeCounts;   
end 


binTimes=calculateBinCentres(edges); 





end





