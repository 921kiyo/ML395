function [result] = testTrees2(T, x2)
% 
% to resolve conflicting positives from underlying trees

n_tree = length(T);

binary_predictions = zeros(size(x2,1),n_tree);
counters = zeros(size(x2,1),n_tree);

for i = 1:length(T)
    [pred, counter] = shortest_tree(T(i), x2);
    binary_predictions(:,i) = pred;
    counters(:,i) = counter;
end

l = size(binary_predictions,1);

result = zeros(l,1);

% combining the trees:
for i = 1:l
    min_length = -1;
    % i.e no trees predict that the example has the emotion
    if(sum(binary_predictions(i,:)) == 0)    
        % arbitrarily choose a random emotion
        result(i) = randi([1,n_tree]);        
    elseif(sum(binary_predictions(i,:)) == 1)
        for j = 1:n_tree
            if binary_predictions(i,j) == 1
                result(i) = j;
            end
        end
    else
        for j = 1:n_tree
            if binary_predictions(i,j) == 1
                if (min_length == -1) || (counters(i,j) < min_length)
                    min_length = counters(i,j);
                    result(i) = j;
                end    
            end
        end
    end
end

end

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
    end  

end

