function [X] = myDFT2(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% myDFT2(x) = X 
% A function that takes a sampled waveform as input and returns the
% Discrete Fourier Transform series. A second method
% Input: x - a series of sampled measurements (amplitudes for a waveform)
% Output: X - the DFT of the input series
% Author: Valerie Ingalls
% Date: 3/4/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = length(x);
n = 0:1:N-1; % make a vector for n to avoid a later loop
X = zeros(N,1); % initialize output vector
for m=0:1:N-1 % loop for each basis function
    % calculate vector of basis functions with the vector of n values
    % included
    basis = cos(2*pi*m*n/N) - 1j*sin(2*pi*m*n/N);
    % point to point multiplication with input values
    newPoint = x .* basis.';
    % sum product results, assign it to output
    X(m+1) = sum(newPoint);
end
end