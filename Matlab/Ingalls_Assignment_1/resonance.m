function [resonantFreq] = resonance(inductance, capacitance)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% resonantFreq = resonance(inductance, capacitance)
% This function takes the overall inductance and capacitance in a circuit
% and calculates the resonant frequency of that circuit.
% Inputs: inductance (overall circuit inductance in Henrys; a scalar)
%         capacitance (overal circuit capacitance in Farads; a scalar)
% Output: resonantFreq (the resonant frequency of the circuit in Hertz)
% Author: Valerie Ingalls
% Created 1/23/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    resonantFreq = 1 / (2*pi*sqrt(inductance*capacitance)); % formula for calculating resonant frequency
end