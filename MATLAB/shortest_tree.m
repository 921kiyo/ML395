function [ prediction_result, counter_result] = shortest_tree( tree, examples )
%SHORTEST_TREE Summary of this function goes here
%   Detailed explanation goes here
    root = tree;
    len_examples = size(examples, 1);
    prediction_result = transpose(1:len_examples);
    counter_result = transpose(1:len_examples);

    for row = 1:len_examples
        tree = root;
        counter = 0;
        % While we still have subtrees
         while tree.op ~= -1
             tree = tree.kids(examples(row,tree.op)+1);
             counter = counter + 1;
         end
         prediction_result(row,1) = tree.class;
         counter_result(row, 1) = counter;
%          prediction_result(row,2) = counter;
    end  

end

