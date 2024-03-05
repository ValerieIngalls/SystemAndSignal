function [X] = myDFT3(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% myDFT3(x) = X 
% A function that takes a sampled waveform as input and returns the
% Discrete Fourier Transform series. A 3rd method
% Input: x - a series of sampled measurements (amplitudes for a waveform)
% Output: X - the DFT of the input series
% Author: Valerie Ingalls
% Date: 3/4/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = length(x);
n = 0:1:N-1; % leaving this as a row for expedient matrix multiplication later
unit = 2 * pi * n/N; % portion of the basis function; avoids repeated definition within loop
Nyquist = floor(N/2);
X = zeros(N, 1); % initializing full output vector; prefer to reassign rather than append later
for m = 0:1:(Nyquist) % loop through basis functions up to the Nyquist rate
    basis = cos(m*unit) - 1j * sin(m*unit); % basis using predefined portion
    X(m+1) = basis * x; % matrix multiplication between input vector and basis function vector
end

% use partial aliasing to fill out the output
if mod(N, 2) == 0 % method for even number of inputs
    X(Nyquist+2:N, :) = flip(conj(X(2:Nyquist, :))); 
else % method for odd number of inputs
    X(Nyquist+2:N, :) = flip(conj(X(2:Nyquist+1, :)));
end