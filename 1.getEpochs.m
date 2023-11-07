function epoch = getEpochs(gloveData,analogData,lenInterval)
% function epoch = getEpoch(srate,lenInterval)
%
% INPUT:
% glove data  - Glove sensor data
% analogData  - Analog data vector
% lenInterval - Length of epochs in seconds
% 
% OUTPUT:
% epoch       - Struct with onsets and labes of each epoch
                                                                                        

%% Plot window of time series
% Analog data jitter and need to be rescaled to match gesture data stream 
% from glove data
analogDataRound = round(analogData*10);

% Data were recorded in two blocks. Timebase defines the length of each
% block.
timebase1 = 1:length(gloveData.gesture{1});

% Timeshift (in sample points) between glove and brain data. (visually 
% defined in advance)
shiftBlock1 = -41886;

% Create new figure
figure

% Plot analog data
plot(analogDataRound);
hold on % holds current figure for more plots

% Data
plot(timebase1+shiftBlock1,gloveData.gesture{1},'--r');
plot(timebase1+shiftBlock1,gloveData.fingers{2,1},'k');
plot(timebase1+shiftBlock1,gloveData.fingers{4,1},'b');
plot(timebase1+shiftBlock1,gloveData.pitch{1},'r');
plot(timebase1+shiftBlock1,gloveData.roll{1},'g');

xlim([0.8e5 1.6e5]);

legend('Analog','Gesture','Hand/Fist','Finger','Pitch','Roll')
title('Glove data timeseries with movement onsets','fontweight','bold')
ylabel('Amplitude','fontweight','bold')


%% Get onsets und offsets of finger movement
exec = 'y';
finger = [];

startTrigger = input('Enlarge window! Ready? [y]    ','s');

while strcmp(exec,'y')
    
    [x y] = ginput(3);
    if length(x) == 3
        finger = [finger x];
    else
        warning('Wrong number of inputs!!!')
    end
    
    exec = input('Next gesture? [y/n]   ','s');
    
    
end

close

%% Define antagonistic intervals > 250 ms
srate = gloveData.srate;
epoch.OnsetIdx = [];
epoch.label = [];

fingerUp=round(finger(1:2,:));
fingerDown=round(finger(2:3,:));
fingerUp(:,(fingerUp(2,:)-fingerUp(1,:))<round(srate*lenInterval)) = [];
fingerDown(:,(fingerDown(2,:)-fingerDown(1,:))<round(srate*lenInterval)) = [];
nbFingerUp = floor(diff(fingerUp,1,1)/(srate*lenInterval));
nbFingerDown = floor(diff(fingerDown,1,1)/(srate*lenInterval));
mFingerUp = mean(fingerUp);
mFingerDown = mean(fingerDown);
for i=1:size(fingerUp,2)
    x = 0:nbFingerUp(i)-1;
    % First onset
    fOnset = mFingerUp(i)-(nbFingerUp(i)/2)*round(srate*lenInterval);
    %
    epoch.OnsetIdx = [epoch.OnsetIdx x*round(srate*lenInterval)+fOnset];
    epoch.label(length(epoch.label)+1:length(epoch.label)+length(x)) = 20;
end
for i=1:size(fingerDown,2)
    x = 0:nbFingerDown(i)-1;
    % First onset
    fOnset = mFingerDown(i)-(nbFingerDown(i)/2)*round(srate*lenInterval);
    %
    epoch.OnsetIdx = [epoch.OnsetIdx x*round(srate*lenInterval)+fOnset];
    epoch.label(length(epoch.label)+1:length(epoch.label)+length(x)) = 21;
end