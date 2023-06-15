%% NNT Calcium Pipeline
%% Setting up the environment 
set(0,'DefaultFigureWindowStyle','normal')
format compact;
addpath(genpath('main'));
addpath(genpath('Pipelines'))
addpath(genpath('Plotting'))

%% Remove ROIs
if exist('badComponents','var') && ~exist('badComFlag','var')
    [DeltaFoverF,dDeltaFoverF,ROI,ROIcentroid,Noise_Power,A] = ...
        removeROI(DeltaFoverF,dDeltaFoverF,ROI,ROIcentroid,Noise_Power,A,unique(badComponents));
    badComFlag = 1;
end
%% Fix centroids
ROIcentroid = [];
for i = 1:length(ROI)
    blah = vertcat(ROI{i}{:});
    ROIcentroid(i,:) = floor(mean(blah,1));
end

%% Parameters 
parameters.caFR = 30.048;
parameters.ts = 1/parameters.caFR;
parameters.caTime = 0:parameters.ts:(size(DeltaFoverF,2)-1)*parameters.ts;
parameters.windowBeforePull = 1; % in seconds
parameters.windowAfterPull = 1; % in seconds
%% Spike detection from dF/F

std_threshold = 3;      % from Carrilo-Reid and Jordan Hamm's papers
static_threshold = .01;
Spikes = rasterizeDFoF(DeltaFoverF,std_threshold,static_threshold);
figure('Name','Spiking Raster');Show_Spikes_new(Spikes);

%% Behavior

[Behaviour] = readLever(parameters);

figure('Name','Average Lever Traces for Hits');
for i=1:Behaviour.nHit
    plot(Behaviour.hitTrace(i).time,Behaviour.hitTrace(i).trace,'Color',[0 0 0 0.2],'LineWidth',1.5);
    hold on;
end
plot(Behaviour.hitTrace(1).time,mean(horzcat(Behaviour.hitTrace(1:end).trace),2),'Color',[1 0 0 1],'LineWidth',2);
yline(15,'--.b','Threshold','LabelHorizontalAlignment','left'); 
ylabel('Lever deflection (in mV)');xlabel('Time (in s)');title('Average Lever Traces for Hits');

figure('Name','Average Lever Traces for Misses');
for i=1:Behaviour.nMiss
    plot(Behaviour.missTrace(i).time,Behaviour.missTrace(i).trace,'Color',[0 0 0 0.2],'LineWidth',1.5);
    hold on;
end
plot(Behaviour.missTrace(1).time,mean(horzcat(Behaviour.missTrace(1:end).trace),2),'Color',[1 0 0 1],'LineWidth',2);
yline(15,'--.b','Threshold','LabelHorizontalAlignment','left'); 
ylabel('Lever deflection (in mV)');xlabel('Time (in s)');title('Average Lever Traces for Misses');


figure();
imagesc(parameters.caTime,1:1:size(DeltaFoverF,1),DeltaFoverF);colormap('hot'); 

