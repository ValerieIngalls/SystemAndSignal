function [rms] = myRMS(X)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% myRMS - myRMS(X)
% A function for calculating the root mean square of input X, which can be
% either a vector or a scalar
% input: X (a vector or scalar)
% output: rms (the root mean square of the input)
% Author: Valerie Ingalls
% Created 1/23/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    N = length(X); % number of values for later mean calculation
    X2 = X.^2; % square individual values in X
    meanX = sum(X2)/N; % add the squared values, then divide by N to get mean
    rms = sqrt(meanX);
end