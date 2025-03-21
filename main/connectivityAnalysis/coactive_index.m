function [coactive_cells,detected_spikes] = coactive_index(Spikes,bin)
%% Calculates the number of celss/ROIs that are active/spiking in a time bin - detected_spikes
%% Calculates the percentage of cells/ROIs that are active in a time bin - coactive_cells

    for i = 1:length(Spikes(1,:))
        total = length(Spikes(:,i));
        detected_spikes(i) = sum(Spikes(:,i));
        coactive_cells(:,i) = detected_spikes(i)./total;
    end
    bins = discretize(1:length(coactive_cells(1,:)),bin); 
    for i = 1:bins(end)
        bin_coactive(i) = sum(coactive_cells(find(bins==i)));
    end
    coactive_cells = bin_coactive;
    