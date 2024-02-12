function [wave, time] = mySine(amplitude, frequency, phase, duration)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mySine(amplitude, frequency, phase, duration) = [wave, time]
%
% Generates a waveform sampled at 22050 Hz with the given parameters
% 
% Inputs: amplitude (peak amplitude of the waveform
%         frequency (frequency of the sinusoid NOT SAMPLING RATE; Hz)
%         phase (starting phase of the waveform)
%         duration (length of the signal; seconds)
% Outputs: wave (amplitude of the waveform as a column vector)
%          time (time that samples are taken as a column vector; seconds)
%
% Author: Valerie Ingalls
% Created 1/30/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    samplingRate = 44100; % adjustable sampling rate
    samplingPeriod = 1/samplingRate; % period is inverse of frequency
    N = round(duration*samplingRate); % number of samples needed
    n = (0:1:N-1).'; % generate index for all needed samples
    time = n .* samplingPeriod; % multiply index by period to give timestamp for each sample
    wave = amplitude*sin(2*pi*frequency*time + phase); % calculate wave value at each time

    plot(time, wave)
    cycles = 5;
    xlim([0,cycles/frequency]);
    ylabel("Amplitude")
    xlabel("Time (sec)")

    soundsc(wave, samplingRate);
end