function [X] = myDFT1(x)
N = length(x);
X = zeros(N,1);
for m=0:1:N-1
    for n=0:1:N-1
        point = x(n+1) * (cos(2*pi*n*m/N) - 1j*sin(2*pi*n*m/N));
        X(m+1) = X(m+1) + point;
    end
end
end