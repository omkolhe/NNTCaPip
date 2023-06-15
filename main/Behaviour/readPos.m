function [vel,pos] = readPos(time)
tic
[enfile,enpath] = uigetfile('*.csv');
if isequal(enfile,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(enpath,enfile)]);
end

B = readmatrix([enpath,'/',enfile]);
posAr = B(:,2);
tAr = B(:,3)/1000;       % time from arduino in ms
velAr = zeros(1,numel(tAr));
velAr(2:end) = movmean(diff(posAr)/(tAr(2)-tAr(1)),500); % the moving average window is kept as the sampling frequency

pos = zeros(1,size(time,2));
vel = zeros(1,size(time,2));
preInd = 1;
for i=2:numel(time)
    ind = max(find(tAr<time(i)));
    pos(i) = posAr(ind);
    vel(i) = mean(velAr(preInd:ind));
    preInd = ind;
end
toc
