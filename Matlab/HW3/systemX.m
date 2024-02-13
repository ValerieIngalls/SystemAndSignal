function [output] = systemX(input,systemNumber)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% output= systemX(input,systemNumber);
% 
% System for analysis in the Signal & System Theory class.
% Students are to check each system (1-4) for linearity.
% input = input waveform: 100 Hz sinusoid 20 ms in length.
% systemNumber = choice of which "system" to evaluate.
%                Use integers 1-4.
% output = output waveform obtained after passing through the system.
%
% Author: Shawn Goodman
% Date: Sept 15, 2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
if nargin < 2
    error('Must specify which "system" to analyze (1-4).')
end
[R,C] = size(input);
if min([R,C]) ~= 1
    error('Input argument (input) must be a column vector.')
else
    input = input(:);
end
output = [];
max_dB = 60;
pRef = 0.00002; 
maxAllowed = 10^(max_dB/20)* pRef; 
rmsIn = sqrt(mean(input.^2)); 
if rmsIn > maxAllowed,
    disp('ERROR: Input RMS amplitude exceed 60 dB SPL.')
    disp(['       Only values <= ',num2str(max_dB),' dB SPL (',num2str(maxAllowed),') are allowed.'])
    return
end
switch systemNumber
    case 1
        output = (input + eps) * sqrt(rmsIn);
    case 2
        output = (input + eps) ./ sqrt(rmsIn);
    case 3
        output = (input + eps) * 3.5;
    case 4
        if rmsIn < 10^(40/20)*pRef 
            output = (input * 0) + eps;
        else
            output = ((input + eps) / max(abs(input))) * (10^(60/20)*pRef);
        end
    otherwise
        
end


