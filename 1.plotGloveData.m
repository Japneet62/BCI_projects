function plotGloveData(gloveData, analogData, trigger)
% plotGloveData(gloveData, analogData)
%
% INPUT:    
% gloveData     - Data structure containing glove sensor values
% analogData    - Analog data vector
% trigger       - On- and offsets of finger movements
%
% PURPOSE:
% Functions temporarly matches glove with brain data and plots time series
% to manually define gesture on- and offsets

%% Initialization

% Analog data jitter and need to be rescaled to match gesture data stream 
% from glove data
analogDataRound = round(analogData*10);

% Data were recorded in one blocks (GP33). Timebase defines the length of each
% block.
timebase1 = 1:length(gloveData.gesture{1});
%timebase2 = 1:length(gloveData.gesture{2});

% Timeshift (in sample points) between glove and brain data. (visually 
% defined in advance)
shiftBlock1 = -41886;


% Create new figure
figure


%% First subplot: Bench sensors
%subplot(2,1,1)
% Plot analog data
plot(analogDataRound);
hold on % holds current figure for more plots


plot(timebase1+shiftBlock1,gloveData.gesture{1},'--r');
plot(timebase1+shiftBlock1,gloveData.fingers{2,1},'k');
plot(timebase1+shiftBlock1,gloveData.fingers{4,1},'b');
plot(timebase1+shiftBlock1,gloveData.pitch{1},'r');
plot(timebase1+shiftBlock1,gloveData.roll{1},'g');


legend('Analog','Gesture','Hand/Fist','Finger','Pitch','Roll')
title('Glove data timeseries with movement onsets','fontweight','bold')
ylabel('Amplitude','fontweight','bold')

% Define y-direction limits for on-,offset plots
lim=get(gca,'YLim');
% Plot on-, offsets
for i=1:length(trigger.label)
    if trigger.label(i)==20
        plot([trigger.OnsetIdx(i) trigger.OnsetIdx(i)],[lim(1) lim(2)],'b');
    elseif trigger.label(i)==21
        plot([trigger.OnsetIdx(i) trigger.OnsetIdx(i)],[lim(1) lim(2)],':b');
    end
end


