function [Behaviour] = readLever(parameters)
%% Reading file from arduino 
[enfile,enpath] = uigetfile('*.csv');
if isequal(enfile,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(enpath,enfile)]);
end

resting_position = 285;
flip = -1;

nlength = round(parameters.windowAfterPull/parameters.ts + parameters.windowAfterPull/parameters.ts + 1);

B = readmatrix([enpath,'/',enfile]);
Behaviour.leverTrace = (B(:,2) - resting_position)*flip;
Behaviour.time = (B(:,4) - B(1,4))/1000.0; % time in seconds
Behaviour.nHit = B(end,5);
Behaviour.nMiss = B(end,6);
Behaviour.B = B;

%% Gettting Hit and miss timings
hitIndex = find(diff(B(:,5)) == 1) + 1;
hitTime = Behaviour.time(hitIndex);
hitCaIndex = zeros(Behaviour.nHit,1);
hitCaTime = zeros(Behaviour.nHit,1);
for i=1:Behaviour.nHit
    hitCaIndex(i) = max(find(parameters.caTime<hitTime(i)));
    hitCaTime(i) = parameters.caTime(hitCaIndex(i));
end
Behaviour.hit = [hitIndex hitTime hitCaIndex hitCaTime];

missIndex = find(diff(B(:,6)) == 1) + 1;
missTime = Behaviour.time(missIndex);
missCaIndex = zeros(Behaviour.nMiss,1);
missCaTime = zeros(Behaviour.nMiss,1);
for i=1:Behaviour.nMiss
    missCaIndex(i) = max(find(parameters.caTime<missTime(i)));
    missCaTime(i) = parameters.caTime(missCaIndex(i));
end
Behaviour.miss = [missIndex missTime missCaIndex missCaTime];

%% get lever traces for hits and miss 

for i=1:Behaviour.nHit
    Behaviour.hitTrace(i).i1 = max(find(Behaviour.time < Behaviour.hit(i,2)-parameters.windowBeforePull));
    Behaviour.hitTrace(i).i0 = Behaviour.hit(i,1);
    Behaviour.hitTrace(i).i2 = max(find(Behaviour.time < Behaviour.hit(i,2)+parameters.windowBeforePull));
    Behaviour.hitTrace(i).rawtrace = Behaviour.leverTrace(Behaviour.hitTrace(i).i1:Behaviour.hitTrace(i).i2);
    Behaviour.hitTrace(i).rawtime = Behaviour.time(Behaviour.hitTrace(i).i1:Behaviour.hitTrace(i).i2) - Behaviour.time(Behaviour.hitTrace(i).i1);
    Behaviour.hitTrace(i).time1 = Behaviour.time(Behaviour.hitTrace(i).i1:Behaviour.hitTrace(i).i2);
    Behaviour.hitTrace(i).t1 = Behaviour.time(Behaviour.hitTrace(i).i1);
    Behaviour.hitTrace(i).t0 = Behaviour.hit(i,2);
    Behaviour.hitTrace(i).t2 = Behaviour.time(Behaviour.hitTrace(i).i2);
    [Behaviour.hitTrace(i).trace,Behaviour.hitTrace(i).time] = resample(Behaviour.hitTrace(i).rawtrace,Behaviour.hitTrace(i).rawtime,parameters.caFR,'spline');
    if (size(Behaviour.hitTrace(i).trace,1)<nlength)
        n1 = size(Behaviour.hitTrace(i).trace,1);
        n2 = nlength;
        Behaviour.hitTrace(i).trace = [Behaviour.hitTrace(i).trace;interp1(1:1:n1,Behaviour.hitTrace(i).trace,[n1+1:1:n2],'linear','extrap')'];
        Behaviour.hitTrace(i).time = [Behaviour.hitTrace(i).time;interp1(1:1:n1,Behaviour.hitTrace(i).time,[n1+1:1:n2],'linear','extrap')'];
    elseif (size(Behaviour.hitTrace(i).trace,1)>nlength)
        Behaviour.hitTrace(i).trace(nlength+1:end) = [];
        Behaviour.hitTrace(i).time(nlength+1:end) = []; 
    end
end

for i=1:Behaviour.nMiss
    Behaviour.missTrace(i).i1 = max(find(Behaviour.time < Behaviour.miss(i,2)-parameters.windowBeforePull));
    Behaviour.missTrace(i).i0 = Behaviour.miss(i,1);
    Behaviour.missTrace(i).i2 = max(find(Behaviour.time < Behaviour.miss(i,2)+parameters.windowBeforePull));
    Behaviour.missTrace(i).rawtrace = Behaviour.leverTrace(Behaviour.missTrace(i).i1:Behaviour.missTrace(i).i2);
    Behaviour.missTrace(i).rawtime = Behaviour.time(Behaviour.missTrace(i).i1:Behaviour.missTrace(i).i2) - Behaviour.time(Behaviour.missTrace(i).i1);
    Behaviour.missTrace(i).time1 = Behaviour.time(Behaviour.missTrace(i).i1:Behaviour.missTrace(i).i2);
    Behaviour.missTrace(i).t1 = Behaviour.time(Behaviour.missTrace(i).i1);
    Behaviour.missTrace(i).t0 = Behaviour.miss(i,2);
    Behaviour.missTrace(i).t2 = Behaviour.time(Behaviour.missTrace(i).i2);
    [Behaviour.missTrace(i).trace,Behaviour.missTrace(i).time] = resample(Behaviour.missTrace(i).rawtrace,Behaviour.missTrace(i).rawtime,parameters.caFR,'spline');
    if (size(Behaviour.missTrace(i).trace,1)<nlength)
        n1 = size(Behaviour.missTrace(i).trace,1);
        n2 = nlength;
        Behaviour.missTrace(i).trace = [Behaviour.missTrace(i).trace;interp1(1:1:n1,Behaviour.missTrace(i).trace,[n1+1:1:n2],'linear','extrap')'];
        Behaviour.missTrace(i).time = [Behaviour.missTrace(i).time;interp1(1:1:n1,Behaviour.missTrace(i).time,[n1+1:1:n2],'linear','extrap')'];
    elseif (size(Behaviour.missTrace(i).trace,1)>nlength)
        Behaviour.missTrace(i).trace(nlength+1:end) = [];
        Behaviour.missTrace(i).time(nlength+1:end) = []; 
    end
end




