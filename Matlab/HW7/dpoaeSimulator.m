
function [Dpoae,fs,f1,f2,fdp] = dpoaeSimulator(len)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [Dpoae,fs,f1,f2,fdp] = dpoaeSimulator(len);
%
% Creates a matrix of simulated distortion product otoacoustic emission
% recordings. Because this was created for teaching purposes, the
% simulation includes mostly the reflection component of the emissions,
% with minimal interference from the distortion component.
%
% len = length of recording matrix in seconds. The value must be >= 0.025 s
%         and <= 1.5 s. Varying this value lets the user explore the
%         effects of differing recording lengths.
% Dpoae = a matrix of recordings. Each column contains one recording waveform.
%         Each recording contains two primary frequencies, f1 and f2, and         
%         one cubic distortion product (fdp = 2*f1 - f2). The primary ratio
%         is f2/f1 = 1.22.
%         f2 spacing is in fractional octaves (1/36). 
%         All primary frequencies are rounded to be integers in Hz.
%         Primary levels are 65,55 for f1 and f2, respectively.
% fs = the waveform sampling rate in Hz.
% f1 = vector of f1 (first primary) frequencies
% f2 = vector of f2 (first primary) frequencies
% fdp = vector of dp (cubic distortion tone) frequencies
%
% Author: Shawn Goodman
% Date: October 22, 2014
% Updated: October 22, 2015
% Created for Dr. Goodman's Signal and System Theory course at the
% University of Iowa, Dept. of Communications Sciences and Disorders
% Last Updated: October 29, 2021 -- ssg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
% TIME --------------------------------------------------------------------
maxLen = 1.5; % maximum length is 1.5 s
minLen = 0.025; % minimum length is 25 ms
% insure valid input arguments
if nargin == 0 % if user does not input the desired length
    error('User must input length of recordings in seconds')
end
if len > maxLen
    len = maxLen;
    disp('WARNING: Maximum length is 1.5 s.')
end
if len < minLen
    len = minLen;
    disp('WARNING: Minimum length is 25 ms.')
end
fs = 44100; % sampling rate in Hz
nSamples = round(fs * len); % number of samples in each waveform
n = (0:1:nSamples-1)';
time = n / fs; % time vector
 
% FREQUENCY ---------------------------------------------------------------
octSpacing = 1/36; % size of f2 spacing in fractional octaves
f2Start = 1000; % first f2 frequency in Hz
f2Finish = 8000; % last f2 frequency in Hz
f2 = 2.^(log2(f2Start):octSpacing:log2(f2Finish))'; % f2 primary frequencies
f2 = round(f2); % force to interger frequencies
fratio = 1.22; % primary frequency ratio
f1 = f2 / fratio; % f1 primary frequencies
f1 = round(f1); % force to integer frequencies
fdp = 2*f1 -f2; % dpoae frequency
fdp = round(fdp); % force to integer frquencies
nFreqs = length(fdp); % number of tested frequencies
 
% LEVEL -------------------------------------------------------------------
L1 = 65; % f1 primary level (dB SPL)
L2 = 55; % f2 primary level (dB SPL)
Ldp = 10; % dpoae level (dB SPL)
Ln = 5; %35; % noise level (dB SPL)
pRef = 0.00002; % pressure reference (Pascals)
a1 = 10^(L1/20)*pRef; % f1 primary level (Pa)
a2 = 10^(L2/20)*pRef; % f2 primary level (Pa)
adp = 10^(Ldp/20)*pRef; % dpoae primary level (Pa)
an = 10^(Ln/20)*pRef; % noise primary level (Pa)
 
% DELAY (Reflection Component) --------------------------------------------
% Delays calculated according to 
%   Shera & Guinan, Recent Developments in Auditory Mechanics, p. 381-387 (2000).
%   Shera, Guinan, & Oxenham, Proc Natl Acad Sci 99, 3318-3323 (2002).
% CF = stimulus frequency, and characteristic freq at basilar membrane (BM) place
% nSfoae = tauSfoae*CF, dimensionless group delay in periods of CF
% nBM = nSfoae/2, dimensionless group delay to CF place on BM, one-half the SFOAE roundtrip time
alpha = 0.37;
beta = 5.5;
for ii=1:length(fdp)
    cf = (fdp(ii)/1000); % center frequency, cf (kHz).
    nBM = beta * cf .^ alpha; % group delay to CF place on BM
    nSfoae = 2 * nBM; % group delay of reflection component to CF
    tauSfoae = nSfoae ./ cf; % emission group delay (ms)
    delay(ii,1) = tauSfoae / 1000; % dpoae delay in seconds
end
% calculate phase shift of each emission component in the recorded waveforms
cycles(1,1) = delay(1) * fdp(1); % phase delay of first dpoae (cycles)
for ii=2:nFreqs % for each frquency calculate...
    df = fdp(ii-1) - fdp(ii); % change in frequency
    tau = mean([delay(ii-1),delay(ii)]); % change in delay
    dc = df * tau; % change in number of cycles
    cycles(ii,1) = cycles(ii-1,1) + dc; % phase delay of each dpoae (in cycles) 
                                        % is the previous phase plus the
                                        % change in the number of cycles.
end
radians = 2*pi*cycles; % put cycles into radians
radians = -angle(exp(1i*radians));
%radians = -wrap(radians); % wrap the radians back between -pi and pi and take the additive inverse
 
 
% WAVEFORMS ---------------------------------------------------------------
doPlot = 0; % turn on and off plotting for each created waveform
Dpoae = zeros(nSamples,nFreqs); % initialize output matrix
jitterdB = 10; % amount to jitter the reflection dp amplitude
for ii=1:nFreqs
    w1 = a1 * cos(2*pi*f1(ii)*time); % f1 primary waveform
    w2 = a2 * cos(2*pi*f2(ii)*time); % f2 primary waveform
    
    jit = rand(1,1)*(jitterdB-1);
    jit = jit - (jitterdB/2);
    jit = 10^(jit/20);
    
    wdpR = (adp*jit) * cos(2*pi*fdp(ii)*time - radians(ii)); % dpoae waveform (reflection component)
    wdpD = (adp/2) * cos(2*pi*fdp(ii)*time); % dpoae waveform (distortion component)
    noise = an * randn(size(time)); % additive noise
    if doPlot
        plot(wdp)
        hold on
        pause
    end
    Dpoae(:,ii) = w1 + w2 + wdpR + wdpD + noise;
end
