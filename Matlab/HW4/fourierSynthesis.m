function [output] = fourierSynthesis(waveType, f0, nthHarmonic)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% output = fourierSynthesis(waveType, f0, nthHarmonic)
% A function to generate a square, triangle, or sawtooth wave through
% Fourier synthesis. Written for Dr. Goodman's System and Signal class,
% Spring 2024
% Inputs:
%   waveType - The desired waveform. Valid inputs are 1 or 'square' for a
%       square wave, 2 or 'triangle' for a triangular wave, and 3 or 'sawtooth'
%       for a sawtooth wave.
%   f0 - The fundamental frequency of the harmonic series used to make the
%       composite wave
%   nthHarmonic - An integer. The highest desired harmonic to be included
% Outputs:
%   output - An Nx1 matrix with the amplitude values of the output wave
%   Also generates a plot of the desired wave
% Author: Valerie Ingalls
% Created 2/16/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% wavetypes set up to all except a number or a string
if all(waveType == 1) || strcmp(waveType, 'square') % square wave
    harmonics = 1:2:nthHarmonic;
    amplitudes = 1 ./ harmonics;
    phase = -1*pi/2;
    % -1*pi/2
    plotTitle = 'Square Wave';

elseif all(waveType == 2) || strcmp(waveType, 'triangle') % triangle wave
    harmonics = 1:2:nthHarmonic;
    amplitudes = 1 ./ harmonics.^2;
    phase = 0;
    plotTitle = 'Triangle Wave';

elseif all(waveType == 3) || strcmp(waveType, 'sawtooth') % sawtooth wave
    harmonics = 1:nthHarmonic;
    amplitudes = 1 ./ harmonics;
    phase = -1*pi/2;
    plotTitle = 'Sawtooth Wave';

else % error message and early exit if one of the correct wave options is not input
    error("Invalid waveform input. Please enter 1, 'square', 2, 'triangle', 3, or 'sawtooth'.")
end

harmonicSeries = f0 * harmonics; % get the series of frequencies we will be combining

yn = 0; % default value that will let us continue past the following checks if there are no issues

if max(harmonicSeries) > 22050 % check if highest harmonic exceeds Nyquist rate; if yes, ask user if they want to continue or end
    yn = input(['Warning: Input parameters yield harmonics that exceed the Nyquist rate and may lead to aliasing.\n' ...
        'Continue anyway? (Y/N) '], "s"); % user input, coerced to string
end

if strcmp(yn, 'N') || strcmp(yn, 'n') % early exit if users desires
    error('Function terminated early by user input. To ensure no aliasing issues, choose a fundamental frequency and highest harmonic that multiply to less than 22050.')
end

% convert to rectangular form
A = amplitudes .* cos(phase);
B = amplitudes .* sin(phase);

% establish time and sampling rate parameters for our waveform
duration = 1;
fs = 44100;
N = round(fs*duration);
t = (0:1:N-1)'/fs;
output = zeros(N, 1); % initialize wave

nHarmonics = length(harmonicSeries); % number of frequencies being added

% parameters for nice plotting
nCycles = 4;
pauseLen = 5/nHarmonics;

figure
% meat of the harmonic calculations and synthesis
for ii = 1:nHarmonics
    newWave = A(ii) * cos(2*pi*harmonicSeries(ii)*t) + B (ii) * sin(2*pi*harmonicSeries(ii) * t); % generate the wave for the ith harmonic
    output = output + newWave; % continuing addition of waves together

    plot(t,output) % plot the most current wave
    xlim([0, nCycles/f0]) % visuals
    xlabel('Time (s)')
    ylabel('Amplitude')
    title([plotTitle, ' after ', num2str(ii), ' of ', num2str(nHarmonics), ' iterations'])
    pause(pauseLen)
end

soundsc(output, fs); % play our final added waveform
end