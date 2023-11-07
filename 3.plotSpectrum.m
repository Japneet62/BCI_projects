function plotSpectrum(data,fs,dataFiltered,log)
% function [Y f] = plotSpectrum(data,fs,dataFiltered)
%
% INPUT:
% data          - Input data (time series)
% fs            - sampling frequency
% dataFiltered  - Optional: Filtered time series
% log           - Optional: give 'log' as 4th input to plot the log of the amplitude spectrum
%
% PURPOSE:
% Plot time series and corresponding amplitude spectrum

% FFt of original time series
L = length(data);
NFFT = 2.^nextpow2(L); % Next higher power of 2 (nextpow2(N) returns the first P such that 2.^P >= abs(N))

Y = fft(data,NFFT)/L;  % Discrete Fourir transform of data, padded with zeros if data has less than NFFT points
f = fs/2*linspace(0,1,NFFT/2+1); % ?

if nargin == 2
    
    figure
    subplot(2,1,1)
    plot(data);
    xlabel('Time [ms]','Fontsize',24);
    ylabel('Amplitude [mV]','Fontsize',24);
    title('Time series')
    
    % plot single sided amplitude spectrum
    subplot(2,1,2)
    plot(f,2*abs(Y(1:NFFT/2+1)))
    xlabel('Frequency [Hz]','Fontsize',24);
    ylabel('|Y(f)|','Fontsize',24);
    title('Amplitude Spectrum')
    
elseif nargin >= 3
    
    figure
    subplot(2,2,1)
    plot(data);
    xlabel('Time [ms]','Fontsize',24);
    ylabel('Amplitude [mV]','Fontsize',24);
    title('Time series - original data')
    
    subplot(2,2,3)
    
    if nargin == 4 && strcmp(log,'log') 
        plot(f,log10(2*abs(Y(1:NFFT/2+1))))  
        ylabel('log |Y(f)|','Fontsize',24);
    else
        plot(f,2*abs(Y(1:NFFT/2+1)))
        ylabel('|Y(f)|','Fontsize',24);
    end
    xlabel('Frequency [Hz]','Fontsize',24);
    title('Amplitude Spectrum - original data')
    
    % FFT of filtered data
    L = length(dataFiltered);
    NFFT = 2^nextpow2(L);
    
    Y = fft(dataFiltered,NFFT)/L;
    f = fs/2*linspace(0,1,NFFT/2+1);
    
    subplot(2,2,2)
    plot(data)
    hold on
    plot(dataFiltered,'r')
    xlabel('Time [ms]','Fontsize',24);
    ylabel('Amplitude [mV]','Fontsize',24);
    title('Time series - original and filtered data')
    legend('original data','filtered data')
    
    subplot(2,2,4)
    if nargin == 4 && strcmp(log,'log') 
        plot(f,log10(2*abs(Y(1:NFFT/2+1))))
        ylabel('log |Y(f)|','Fontsize',24);
    else
        plot(f,2*abs(Y(1:NFFT/2+1)))
        ylabel('|Y(f)|','Fontsize',24);
    end
    xlabel('Frequency [Hz]','Fontsize',24);
    title('Amplitude Spectrum - filtered data')
end