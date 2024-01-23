function [wl] = wavelength(freq)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% wl = wavelength(freq)
% A function that calculates the wavelength of an acoustic wave given its
% frequency.
% Input: freq (the frequency of an acoustic wave in Hertz; a scalar)
% Output: wl (the corresponding wavelength in meters)
% Author: Valerie Ingalls
% Created 1/23/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    c = 343; % ~speed of sound in dry air
    wl = c/freq; % formula for wavelength
end