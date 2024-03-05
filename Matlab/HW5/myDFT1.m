function [X] = myDFT1(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% myDFT1(x) = X 
% A function that takes a sampled waveform as input and returns the
% Discrete Fourier Transform series. A first method
% Input: x - a series of sampled measurements (amplitudes for a waveform)
% Output: X - the DFT of the input series
% Author: Valerie Ingalls
% Date: 3/4/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = length(x);
X = zeros(N,1); % initialize output vector
for m=0:1:N-1 % outer loop for each basis function
    for n=0:1:N-1 % inner loop for each input value
        % calculate the input value times the basis function
        point = x(n+1) * (cos(2*pi*n*m/N) - 1j*sin(2*pi*n*m/N));
        % sum the new product
        X(m+1) = X(m+1) + point;
    end
end
end