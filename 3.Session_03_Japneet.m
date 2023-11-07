%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Seminar HCI and BCI in practice
% 
% Session 3
% 
% Filtering and frequency spectrum:
% In this session the prepared ECoG data are filtered and transformed to 
% frequency space. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc; 

% Our ECoG data should be bandpass filtered in the range of [0.3 200] Hz, because most movement related information
% is expected to occur in the high-gamma band >65 Hz. 
% But to understand filters a bit better, we will first have a look at some
% simulated data and then one single trial of the ECoG data, before actually 
% filtering the whole ECoG data. 


%% Simulated data example

% creating simulated data
Fs = 1000; % sample frequency
L = 1000;  % length of simulated data
t = (0:L-1)*(1/Fs); % time points % step size in 1 ms
% the 1st time point = 1*1/1000 = 1 ms
% we take a sample every 1 ms

y = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t); % 50 Hz and 120 Hz
% above, we see 2 sin waves, 

y = y + 2*randn(size(t)); % adding random noise
% random noise: is like gaussian noise. it has a mean = 0. 

% Butterworth filter design 
% [b,a] = butter(n,Wn/nyquist,'type')
% n = filter order

% NOTE: We have to specify the freq as 1. 

% Wn = normalized cutoff frequency
% 'type' = filter type ('low', 'high', 'stop', 'bandpass')
% It returns the filter coefficients vectors b andÂ a, with coefficients in descending powers ofÂ z.


% Filter example: Stop band at 120 Hz

[b,a] = butter(3,[119 121]/500,'stop'); % This is normalised freq % should be 1 at nyquist frequency
dataFiltered = filtfilt(b,a,y);

% Practice: remove filt filt with only 1 filt and see whats the difference.
% We are basically filtring 2 times instaed of 1. 

% plotting the original data and the filtered data and both amplitude spectrums
plotSpectrum(y,Fs,dataFiltered,'log')

%% TASK 1 (2 pt):
% Look into the documentation of “filter” and “filtfilt”. 
% What is the most important difference between the two functions?

% Ans: 
% y = filter(b,a,x) filters the input data x using a rational transfer function
% defined by the numerator and denominator coefficients b and a.
% If a(1) is not equal to 1, then filter normalizes the filter coefficients
% by a(1). Therefore, a(1) must be nonzero. (once-forward)

%y = filtfilt(b,a,x) performs zero-phase digital filtering by processing the
%input data, x, in both the forward and reverse directions. After filtering
%the data in the forward direction, filtfilt reverses the filtered sequence
%and runs it back through the filter. (twice-forward and reverse)



% Change the parameters to create a 
[b,a] = butter(4,[150]/500,'low');
dataFiltered150= filtfilt(b,a,y);   % low pass filter (e.g. cutoff at 150 Hz) 
plotSpectrum(y,Fs,dataFiltered150,'log')

[d,c] = butter(4,[30]/500,'high');
dataFiltered30 = filtfilt(d,c,y);    %high pass filter (e.g. cutoff at 30 Hz)   
plotSpectrum(y,Fs,dataFiltered30,'log')

[f,e] = butter(8,[30,120]/500,'bandpass');
dataFilteredBand = filtfilt(f,e,y); %bandpass filter (e.g. 30-120 Hz)
plotSpectrum(y,Fs,dataFilteredBand,'log')

% (Note: when using high, low or bandpass filters you may want to plot the log
% of the amplitude spectrum for better visualization, add 'log' as 4th
% input parameter (plotSpectrum(y,Fs,dataFiltered,'log'))
% Try changing the filter order. What influence does this have?

% Changes the sharpness of the spectrum

% changes the no of coeffiecients 
% How does the number of coefficients depend on the filter order?

% Use fvtool(b,a) to understand the effects better.

%% Example trial from ECoG data
clc; clear all; 

% Before filtering the whole data, we will have a look at just one trial, to be
% able to visualize the results of the filtering.

% Load data file to workspace (results from session 2)
load ecogStruct2.mat

% Load trial onset information
load epoch2.mat

% Cut timeseries in single trials defined by onset values in epoch2.mat
ecog = ecogSegmentTS(ecog,epoch.OnsetIdx,0,round(0.25*epoch.srate));

% TASK 2 (2 pt):
% Have a look at the ecog structure. What has changed? How is the data arranged? 
% Choose a trial between 1 and length(epoch.label) and a channel between 1
% and 40 - try to avoid previously rejected channels!
selectChannel = 20;
selectTrial = 200;
data = ecog.data(selectChannel,:,selectTrial);

% Nyquist frequency
nyquistFreq = 1000/ecog.sampDur/2;

% Example:
[b,a] = butter(3,[0.3 200]/nyquistFreq,'bandpass'); % Order 3, bandpass (0.3-200 Hz) Filter
dataFiltered = filtfilt(b,a,data);

% TASK 3 (Discussion):
% What is the Nyquist Frequency? 
% Why do we need it here for the butterworth filter design? 

%To get cutoff freq of butterworth filter. Cutoff frequency is that 
%frequency where the magnitude response of the filter is sqr(1/2). 
%For butter, the normalized cutoff frequency Wn must be a number 
%between 0 and 1, where 1 corresponds to the Nyquist frequency, ? radians per sample.
%To convert from frequency in Hz to normalized frequency divide 
%the desired cutoff frequency in Hz by 1/2 the sampling rate.

% Use the plotSpectrum function to visualize the results of the filter.
% (Look at a few different trials and change the filter order to see the
% influence) Are you satisfied with the results of the filter? % yes 
plotSpectrum(data,epoch.srate,dataFiltered,'log')

% Remove the 'log' command
plotSpectrum(data,epoch.srate,dataFiltered) % we observe a change in the frequency figure. 



%% Our ECoG Data
% Filtering the whole data

% Clear workspace and proceed with the BCI data
clear all; close all; clc; 

% Load ecog data again
load ecogStruct2.mat

% Nyquist frequency
nyquistFreq = 1000/ecog.sampDur/2; 

% Compute filter coefficients a & b
[b,a] = butter(3,[0.3 200]/nyquistFreq, 'bandpass');

tmp = ecog.data'; %filtfilt operates along columns

% Filter the data
ecog.data = filtfilt(b,a,tmp)'; 

%% Cut single trials from time series 

% Load trial onset information
load epoch2.mat

% Cut timeseries in single trials defined by onset values in epoch2.mat
ecog = ecogSegmentTS(ecog,epoch.OnsetIdx,0,round(0.25*epoch.srate));

%% Frequency spectrum

% To transform the data to frequency space the Spectral Analysis Toolbox,
% a component of the Chronux toolbox, is used.
% We will use the mtspectrumc function of this toolbox. The second input to
% this function has to be a structure (params) containing six specific fields
% (tapers, Fs, fpass, pad, err, trialave).

% Defining the parameters in the structure params:
ecog.periodogram.params.tapers = [3 5]; 
ecog.periodogram.params.Fs = 1000/ecog.sampDur; 
ecog.periodogram.params.fpass = [0.3 ecog.periodogram.params.Fs/2]; 
ecog.periodogram.params.pad = 0; 
ecog.periodogram.params.err = 0;
ecog.periodogram.params.trialave = 0;

%%  TASK 4 (2 pt):
% Have a look at the documentation of chronux (doc chronux) and the mtspectrumc function.
% What do the fields of the structure params contain? 

  %These are various parameters used in the spectral calculations. Since
  %these parameters are used by most routines in Chronux, they are stored in
  %a single structure params
  
% What is the multi-taper spectral estimation method and what are tapers? 

%In signal processing, the multitaper method is a technique developed by 
%David J. Thomson to estimate the power spectrum SX of a stationary ergodic
%finite-variance random process X, given a finite contiguous realization of
%X as data. It is one of a number of approaches to spectral density estimation.

%Tapers :
           %(1) A numeric vector [TW K] where TW is the
           %time-bandwidth product and K is the number of
               %tapers to be used (less than or equal to
               %2TW-1). 
           %(2) A numeric vector [W T p] where W is the
               %bandwidth, T is the duration of the data and p 
               %is an integer such that 2TW-p tapers are used. In
              % this form there is no default i.e. to specify
               %the bandwidth, you have to specify T and p as
               %well. Note that the units of W and T have to be
               %consistent: if W is in Hz, T must be in seconds
               %and vice versa. Note that these units must also
               %be consistent with the units of params.Fs: W can
               %be in Hz if and only if params.Fs is in Hz.
              % The default is to use form 1 with TW=3 and K=5
 
% What does the definition ecog.periodogram.params.pad = 1 lead to? What
% happens if pad is -1 or 0?
%  pad:   (padding factor for the FFT) - optional (can take values -1,0,1,2...). 
          %-1 corresponds to no padding, 0 corresponds to padding
          %to the next highest power of 2 etc.
 			 % e.g. For N = 500, if PAD = -1, we do not pad; if PAD = 0, we pad the FFT
 			      % to 512 points, if pad=1, we pad to 1024 points etc.
 			       %Defaults to 0.
% Look at the for-loop below: What are the outputs [s,f] going to contain?
%matrix Channels/time points
% And where will this information be stored in the ecog structure?
%


for k = 1:size(ecog.data,3)    % loop through trials
    tmp = squeeze(ecog.data(:,:,k));

    [s,f] = mtspectrumc(tmp',ecog.periodogram.params); % for the mtspectrumc function, the data matrix 
    % should be in the form times*channels, that is why tmp(channels*time points) is transposed

    if k == 1
        ecog.periodogram.periodogram = zeros([size(s), size(ecog.data,3)]);
        ecog.periodogram.centerFrequency = f;
    end
    ecog.periodogram.periodogram(:,:,k) = s;
end

%% Save current results to workspace
save ecogStruct3.mat ecog