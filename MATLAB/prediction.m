function [ prediction_result ] = prediction( tree, examples )
%PREDICTION Summary of this function goes here
%   Detailed explanation goes here
    root = tree;
    len_examples = size(examples, 1);
    prediction_result = transpose(1:len_examples);
    
    for row = 1:len_examples
        tree = root;
        % Iterate through the subtrees
         while tree.op ~= -1
             tree = tree.kids(examples(row,tree.op)+1);
         end
         prediction_result(row,1) = tree.class;
    end   
end

