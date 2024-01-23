function [resonantFreq] = canalResonance(canalLength)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% resonantFreq = canalResonance(canalLength)
% A function to calculate the resonant frequency of an ear canal given its
% length
% Input: canalLength (length of the ear canal in cm; a scalar)
% Output: resonantFreq (the resonant frequency of that canal in Hz)
% Author: Valerie Ingalls
% Created 1/23/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    c = 343000; % approximate speed of sound in cm/s
    resonantFreq = c/(4*canalLength);
end