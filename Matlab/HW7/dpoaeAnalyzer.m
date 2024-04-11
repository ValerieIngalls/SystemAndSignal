function [frequency,phase] = dpoaeAnalyzer(Dpoae,fs,f1,f2,fdp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [frequency,phase] = dpoaeAnalyzer(Dpoae,fs,f1,f2,fdp)
%
% Analyzes input matrix of DPOAE waveforms and returns frequency-domain
% results. For use with the function dpoaeSimulator.m.
%
% Dpoae = a matrix of recordings. Each column contains one recording waveform.
%         Each recording contains two primary frequencies, f1 and f2, and         
%         one cubic distortion product (fdp = 2*f1 - f2). The primary ratio
%         is f2/f1 = 1.22.
%         f2 spacing is in fractional octaves (1/36). 
%         All primary frequencies are rounded to be integers in Hz.
%         Primary levels are 65,55 for f1 and f2, respectively.
% fs = sampling rate (Hz) of the waveforms.
% f1 = vector of f1 (first primary) frequencies
% f2 = vector of f2 (first primary) frequencies
% fdp = vector of dp (cubic distortion tone) frequencies
%
% frequency = 2f1-f2 DPOAE frequency (Hz)
% phase = 2f1-f2 DPOAE phase (rad) re: f2 stimulus phase.
%
% Author: Shawn Goodman
% Date: October 22, 2014
% Updated: October 22, 2015
% Created for Dr. Goodman's Signal and System Theory course at the
% University of Iowa, Dept. of Communications Sciences and Disorders
% Last Updated: October 29, 2021 -- ssg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
[nSamples,nRecordings] = size(Dpoae); 
nfft = fs; % number of samples in the DFT (using fs gives 1-Hz spacing)
DP = fft(Dpoae,nfft); % calculate fft of each column
frequency = (0:1:nSamples-1)'*(fs/nfft); % frequency vector
nyquist = nfft/2; % the nyquist frequency
DP = DP(1:nyquist,:); % cut down to unaliased portion only
frequency = frequency(1:nyquist);
DP = DP / (0.5*nfft); % scale output (zero Hz and nyquist are wrong, but not important here)
pRef = 0.00002; % pressure reference (Pa)
M = 20*log10(abs(DP)/pRef); % magnitude in dB SPL
P = angle(DP); % phase in radians
 
% get the magnitudes and phases of each recording
doPlot = 0;
noiseShift = 40; % number of Hz offset for noise estimate
binShift = round(40 / (fs/nfft));
for ii=1:nRecordings % examine each spectrum to extract the important information
    [dummy,indxF1] = min(abs(f1(ii)-frequency)); % index of f1
    [dummy,indxF2] = min(abs(f2(ii)-frequency)); % index of f2
    [dummy,indxFdp] = min(abs(fdp(ii)-frequency)); % index of fdp
    indxNoise = indxFdp - binShift;
    magF1(ii,1) = M(indxF1,ii); % magnitude of F2
    magF2(ii,1) = M(indxF2,ii); % magnitude of F2
    magDP(ii,1) = M(indxFdp,ii); % magnitude of DP
    magNoise(ii,1) = M(indxNoise,ii); % magnitude of noise floor
    phiF1(ii,1) = P(indxF1,ii); % phase of F2
    phiF2(ii,1) = P(indxF2,ii); % phase of F2
    phiDP(ii,1) = P(indxFdp,ii); % phase of DP
    if doPlot
       plot(frequency,M(:,ii))
       hold on
       plot(frequency(indxF1),magF1(ii,1),'r*')
       plot(frequency(indxF2),magF2(ii,1),'r*')
       plot(frequency(indxFdp),magDP(ii,1),'g*')
       xlim([250 5000])
       hold off
       pause
    end
end
phiDP = phiDP - phiF2; % set dp phase relative to the stimulus
phase = phiDP; % output variable: phase
frequency = fdp; % output variable: frequency

