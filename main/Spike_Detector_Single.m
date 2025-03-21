function Spikes = Spike_Detector_Single(DeltaFoverF,stddev,spikemin)

%% Description 
% % Inputs
% 1. DeltaFoverF - dF/F traces (cells x time)
% 2. stddev - standard deviation about the mean of dF/F traces, above which spike is detected 
% 3. spikemin - the bare minimum dF/F value for spike detection threshold (help in rejecting bad/mislabelled cells)

% % Output
% Spikes - 2D matrix of cell x time with 1 representing spike detected at
% the time step

%% Reference - 

Spikes = zeros(size(DeltaFoverF,1),size(DeltaFoverF,2),size(DeltaFoverF,3));

avghx = mean(mean(DeltaFoverF(:,:,:)));
for j = 1:size(DeltaFoverF,1)   % iterating over cells
    tempSpikes = Spikes(j,:);
    dev = stddev*mean(std(DeltaFoverF(j,:,:)));
    temp = DeltaFoverF(j,:);
    tempSpikes(temp>= dev + avghx & temp >= spikemin) = 1;
    Spikes(j,:) = tempSpikes;
end
