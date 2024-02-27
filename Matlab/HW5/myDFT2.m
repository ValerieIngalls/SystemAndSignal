function [X] = myDFT2(x)
N = length(x);
X = zeros(N,1);
for m=0:1:N-1
    basis = cos(2*pi*m/N*(0:1:N-1)) - 1j*sin(2*pi*m/N*(0:1:N-1));
    X(m+1) = basis * x;
end
end