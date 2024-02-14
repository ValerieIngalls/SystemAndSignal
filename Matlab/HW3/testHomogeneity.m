function [gainMat] = testHomogeneity(system, resolution)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gainMat = characterize(system, [resolution])
% Runs tests on a predefined system from System & Signal class to determine
% homogeneity. Yields four plots and measures of gain across input amplitudes.
% Inputs:
%       system - an integer 1-4; controls which system is being examined
%       resolution - an optional input that controls the dB step size used
%           to generate test amplitudes. Defaults to a 1 dB step size.
% Output:
%       gainMat - a 2xN matrix with values of the gain obtained from each
%           test wave form (columns). Output for convenient reference. Row
%           1 is Linear, row 2 is the dB conversion
%       Also creates I/O and Gain plots in both linear and log units
% Author: Valerie Ingalls
% Created 2/12/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin < 2 % default value gives ease of use alongside flexibility
        resolution = 1;
    end

    fs = 44100;
    N = round(0.02*fs);
    n = (-10:1:N-1).';
    time = n .* 1/fs;
    wave = 1*sin(2*pi*100*time); % generate a sinusoid; 100Hz, 20ms, unit amplitude

    amplitudesSPL = (1:resolution:60); % arbitrary vector of test amplitudes in dB SPL
    amplitudesPa = 0.00002 * 10.^(amplitudesSPL ./ 20); % convert dB to pascals

    paMat = wave*amplitudesPa; % vector multiplication gives us a matrix of test waveforms

    % trying this with no hard-coding
    wid = width(paMat);
    
    rmsInputPa = rms(paMat); % built in rms function works by column

    rmsOutputPa = zeros(1, wid); % preallocating
    % not super needed for something this small but good habits

    for ii = 1:wid
        processedWave = systemX(paMat(:,ii), system);
        rmsOutputPa(1, ii) = rms(processedWave);
    end
    
    % calculate dB values
    rmsInputSPL = 20 * log10(rmsInputPa ./ 0.00002);
    rmsOutputSPL = 20 * log10(rmsOutputPa ./ 0.00002);
    
    % Gain as one matrix for simple output
    % Want to output just for convenient spot checks
    gainMat(1, :) = rmsOutputPa ./ rmsInputPa;
    gainMat(2, :) = rmsOutputSPL - rmsInputSPL;
    
    
    %%%%% Graphing %%%%%
    
    x = 0:0.001:0.015; % for reference line
    % Linear I/O
    figure
    plot(rmsInputPa, rmsOutputPa, x, x, '--')
    title('Linear I/O')
    xlabel('Input RMS Amplitude (Pascals)')
    ylabel('Output RMS Amplitude (Pascals)')
    
    bigx = 0:1:60;
    % Log I/O
    figure
    plot(rmsInputSPL, rmsOutputSPL, bigx, bigx, '--')
    title('Log I/O')
    xlabel('Input RMS Amplitude (dB SPL)')
    ylabel('Output RMS Amplitude (dB SPL)')

    % Linear Gain
    figure
    plot(rmsInputPa, gainMat(1,:))
    title('Linear Gain')
    xlabel('Input RMS Amplitude (Pascals)')
    ylabel('Gain')
    xlim([0 0.015])
    ylim([.67*min(gainMat(1,:)), 1.5*max(gainMat(1,:))])

    % Log Gain
    figure
    plot(rmsInputSPL, gainMat(2, :))
    title('Log Gain')
    xlabel('Input RMS Amplitude (dB SPL)')
    ylabel('Gain (dB SPL)')
    xlim([0 60])
    ylim([min(gainMat(2,:) - 5), max(gainMat(2,:)) + 5])
end