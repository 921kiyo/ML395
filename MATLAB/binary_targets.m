function [ matrix ] = binary_targets(val,y)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    matrix = y;
    matrix(matrix ~= val) = 0;
    matrix(matrix==val) = 1;
end

