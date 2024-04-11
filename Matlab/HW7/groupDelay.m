function [singleTau, firstOrderTau, polyTau, p] = groupDelay(frequency, phase)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [singleTau, firstOrderTau, polyTau] = groupDelay(frequency, phase);
%
% A function to measure group delay of an input signal given frequency and
% phase. Creates several plots, and calculates group delay using three
% different methods: simple "linear" fit, first order difference, and
% fitting a 3rd order polynomial between frequency and phase.
% 
% Plots Created:
%   1. Wrapped and Unwrapped phase as a function of frequency
%   2. The fitted polynomial and unwrapped phase as functions of frequency
%   3. Group delay as calculated by first order difference and polynomial
%      fitting, as a function of frequency.
%
% frequency: a frequency vector for your signal of interest
% phase: a corresponding phase vector for your signal of interest
% singleTau: group delay estimate using a simple linear fit (scalar)
% firstOrderTau: a vector of group delay estimates using obtained using
%   first order difference. Contains a 0 at index 1 for cleaner mapping
%   against frequency.
% polyTau: a vector of group delay estimates obtained by taking the
%   derivative of a third order polynomial fit to the phase.
% p: the set of coefficients for the fitted polynomial. Including for
%   convenient manual checking/analysis.
%
% Author: Valerie Ingalls
% Date: 3/25/2024
% Created for Dr. Goodman's Signal and System Theory course at the
% University of Iowa, Dept. of Communications Sciences and Disorders
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
omega = 2*pi*frequency; % frequency in radians

figure % create a new figure to avoid erasing or overlapping previous runs
hold on
plot(omega, phase, "b") % wrapped phase

uwphase = unwrap(phase); % unwrapped phase
plot(omega, uwphase, "r") % choosing to plot on same figure as wrapped phase for comparison
title("Phase by Frequency")
legend('Wrapped Phase', 'Unwrapped Phase')
ylabel("Phase")
xlabel("Frequency (Rad)")

% line through the endpoints
deltaphase = uwphase(end) - uwphase(1); % rise
deltafreq = omega(end) - omega(1); % run
singleTau = -deltaphase / deltafreq; % slope, flipped sign

% first order difference
firstOrderTau = -diff(uwphase) ./ diff(omega);

% polynomial fit
p = polyfit(omega, uwphase, 3); % cubic
% yields a strong fit; little improvement seen with 4th order, and 2nd
% order shows problematic behavior at the upper end

fit = polyval(p, omega); % generate y-values for the fit based on generated coefficients

figure
hold on
plot(omega, uwphase, "b") % plot fit against phase
plot(omega, fit, "r-")
title("Polynomial Fit of Unwrapped Phase")
legend('Unwrapped Phase', 'Polynomial Fit')
ylabel("Phase")
xlabel("Frequency (Rad)")

% take the derivative to calculate delay
dp = -polyder(p);
polyTau = polyval(dp, omega);

% brief pitstop to add a 0 to the front of the first order difference
% delay vector
len = length(firstOrderTau);
dummyTau = zeros(len + 1, 1);
dummyTau(2:end) = firstOrderTau;
firstOrderTau = dummyTau;

% plotting delays against frequency for comparison
figure
hold on
plot(omega, polyTau, "r-")
plot(omega, firstOrderTau, "b")
title("Group Delay by Frequency")
legend('Polynomial Fit', 'First Order Difference')
ylabel("Group Delay")
xlabel("Frequency (Rad)")
end