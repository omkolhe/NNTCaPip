function [stateSpike,stateSpikeFrame] = spikeState(Vel,Spikes,time,CaFR,thresh,state)
if state
    velFlag = find(abs(Vel)>=thresh); % Find indices of vel threshold
    disp('Analyzing Run states!')
else
    velFlag = find(abs(Vel)<thresh); % Find indices of vel threshold
    disp('Analyzing Rest states!')
end
%%Generate Rest/Run Ca Spikes
idx = diff(velFlag); % Find where there are breaks across indices
idx = find(idx>3); % Segment those breaks
velFlagTime = linspace(0,time(end),length(Vel));
velFlagTime = ceil(velFlagTime*CaFR); %Change to frames
stateSpikeFrame = [];
for i = 1:length(idx)+1
    if i==1 % ie. we want to include 1
        win = velFlag(1:idx(i));
        win2 = velFlagTime(win(1):win(end));
        if win2(1)==0 % catches exception if idx includes first frame of Spikes
            win2(1)=1;
        end
        if state && (win2(1)-ceil(5*CaFR))>=1 % If in running state include intiation phase
            stateSpike{i} = Spikes(:,(win2(1)-ceil(5*CaFR)):win2(end));
            stateSpikeFrame = horzcat(stateSpikeFrame,(win2(1)-ceil(5*CaFR)):win2(end));
        else
            stateSpike{i} = Spikes(:,win2(1):win2(end));
            stateSpikeFrame = horzcat(stateSpikeFrame,win2(1):win2(end));
        end
    elseif i ~=length(idx)+1
        win = velFlag(idx(i-1)+1:idx(i));
        win2 = velFlagTime(win(1):win(end));
        if state
            stateSpike{i} = Spikes(:,(win2(1)-ceil(5*CaFR)):win2(end));
            stateSpikeFrame = horzcat(stateSpikeFrame,(win2(1)-ceil(5*CaFR)):win2(end));
        else
            stateSpike{i} = Spikes(:,win2(1):win2(end));
            stateSpikeFrame = horzcat(stateSpikeFrame,win2(1):win2(end));
        end
    else % from the last break till the end of the segment
        win = velFlag(idx(i-1)+1:end);
        win2 = velFlagTime(win(1):win(end));
        if state
            stateSpike{i} = Spikes(:,(win2(1)-ceil(5*CaFR)):win2(end));
            stateSpikeFrame = horzcat(stateSpikeFrame,(win2(1)-ceil(5*CaFR)):win2(end));
        else
            stateSpike{i} = Spikes(:,win2(1):win2(end));
            stateSpikeFrame = horzcat(stateSpikeFrame,win2(1):win2(end));
        end
    end
end