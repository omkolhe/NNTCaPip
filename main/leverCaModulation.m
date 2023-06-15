function leverCaModulation(DeltaFoverF,Behaviour)
caM = mean(DeltaFoverF,2);
for i = 1:Behaviour.nHit
    Calcium.hit.caTrace(i).DeltaFoverF = DeltaFoverF(:,Behaviour.hitTrace(i).caIndex);
    Calcium.hit.modulationIdx(:,i) = single(1.2*mean(Calcium.hit.caTrace(i).DeltaFoverF,2)>caM);
    Calcium.hit.modulationIdxM = mean(Calcium.miss.modulationIdx,2);
end
for i = 1:Behaviour.nMiss
    Calcium.miss.caTrace(i).DeltaFoverF = DeltaFoverF(:,Behaviour.missTrace(i).caIndex);
    Calcium.miss.modulationIdx(:,i) = single(1.2*mean(Calcium.miss.caTrace(i).DeltaFoverF,2)>caM);
    Calcium.miss.modulationIdxM = mean(Calcium.miss.modulationIdx,2);
end
% Define motor neurons (modulation during miss and hit trials)

% Define hit/reward neurons (modulated stronger during hit trials)

% Define miss neurons (modulated stronger during miss trials)
end