function [ prediction_result ] = prediction( tree, examples )
%Function to get 
    root = tree;
    len_examples = size(examples, 1);
    prediction_result = transpose(1:len_examples);
    % While we still have subtree, iterate through the subtrees
    for row = 1:len_examples
        tree = root;
         while tree.op ~= -1
             tree = tree.kids(examples(row,tree.op)+1);
         end
         prediction_result(row,1) = tree.class;
    end   
end

