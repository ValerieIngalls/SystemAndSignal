function [pascals] = dbToPascals(dB_SPL)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pascals = dbToPascals(dB_SPL)
% A function for converting pressure in dB SPL to Pascals
% input: dB_SPL (pressure in dB_SPL
% output: pascals (pressure in pascals)
% Author: Valerie Ingalls
% Created 1/23/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    pascals = 0.00002 * 10^(dB_SPL / 20);
end