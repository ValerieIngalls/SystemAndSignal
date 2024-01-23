function [dB_SPL] = pascalsToDB(pascals)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dB_SPL = pascalsToDB(pascals)
% A function for converting pressure in pascals to dB SPL
% input: pascals (pressure in pascals)
% output: dB_SPL (pressure in dB SPL)
% Author: Valerie Ingalls
% Created 1/23/2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    dB_SPL = 20 * log10(pascals / 0.00002);
end