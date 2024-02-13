function [gainMat] = characterize(system, resolution)
    
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

    gainMat(1, :) = rmsOutputPa ./ rmsInputPa;
    gainMat(2, :) = rmsOutputSPL - rmsInputSPL;
    
    
    %%%%% Graphing %%%%%
    
    x = 0:0.001:0.02; % for reference line
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
    xlim([0 0.015]);

    % Log Gain
    figure
    plot(rmsInputSPL, gainMat(2, :))
    title('Log Gain')
    xlabel('Input RMS Amplitude (dB SPL)')
    ylabel('Gain (dB SPL)')
    xlim([0 60])
end