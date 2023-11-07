function plotOwnLabels(gloveData, analog, ownEpochs)
% plotGloveData(gloveData, analogData)
%
% INPUT:    
% gloveData     - Data structure containing glove sensor values
% analogData    - Analog data vector
% ownEpochs
%
% PURPOSE:
% Plots self-defined labels

%% Initialization

% Analog data jitter and need to be rescaled to match gesture data stream 
% from glove data
analogDataRound = round(analog*10);
% Timebase defines the length of each
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

xlim([0.8e5 1.6e5])

legend('Analog','Gesture','Hand/Fist','Finger','Pitch','Roll')
title('Glove data timeseries with movement onsets','fontweight','bold')
ylabel('Amplitude','fontweight','bold')

% Define y-direction limits for on-,offset plots
lim=get(gca,'YLim');
% Plot on-, offsets
for i=1:length(ownEpochs.label)
    if ownEpochs.label(i)==20
        plot([ownEpochs.OnsetIdx(i) ownEpochs.OnsetIdx(i)],[lim(1) lim(2)],'b');
    elseif ownEpochs.label(i)==21
        plot([ownEpochs.OnsetIdx(i) ownEpochs.OnsetIdx(i)],[lim(1) lim(2)],':b');
    end
end