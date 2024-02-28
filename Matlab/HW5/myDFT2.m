function [X] = myDFT2(x)
N = length(x);
n = 0:1:N-1;
X = zeros(N,1);
for m=0:1:N-1
    basis = cos(2*pi*m*n/N) - 1j*sin(2*pi*m*n/N);
    newPoint = x .* basis';
    X(m+1) = sum(newPoint);
end
end