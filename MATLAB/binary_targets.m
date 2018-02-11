function [ matrix ] = binary_targets(val,y)
% Function to map labels in y into binary for a particular emotion
    matrix = y;
    matrix(matrix ~= val) = 0;
    matrix(matrix==val) = 1;
end

