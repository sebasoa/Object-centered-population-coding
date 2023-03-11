function [rateMapArray,edgesX_array,edgesY_array]=rateMapData(posArray,spikeArray)
%rateMapData.m 
%   

numConditions=2;

rateMapArray=cell(1,numConditions); 
edgesX_array=cell(1,numConditions); 
edgesY_array=cell(1,numConditions); 

lim=[0,150,0,150]; 
binSize=3; 



for g=1:2
 
    pos=posArray{g};
    spikes=spikeArray{g};
    map=calculateRateMap(pos,spikes(:,1),'smooth',2,'blanks','off','binWidth',binSize,'limits',lim);
    
    rateMapArray{g}=map.z;
    edgesX_array{g}=map.x;
    edgesY_array{g}=map.y;
    
end 






end 