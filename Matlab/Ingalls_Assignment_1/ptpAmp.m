function [amplitude] = ptpAmp(X)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% amplitude = ptpAmp(X)
% A function to calculate peak to peak amplitude of vector X, i.e. the
% distance between its highest and lowest values
% Input: X (a vector of values)
% Output: amplitude (the peak to peak amplitude of values in the vector)
% Author: Valerie Ingalls
% Created 1/23/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    peak1 = max(X); % find the largest value in X
    peak2 = min(X); % find the smallest value in X
    amplitude = peak1 - peak2; % obtain the distance between them
end