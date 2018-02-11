function [result] = testTrees3(T, x2)
% Function to comgine 6 trees based on the number of example in each leaf.
% if no binary trees predict a class, we choose randomly
% if one binary tree predicts a class, we select that tree
% if >1 binary tree predicts a class, we select the tree with minimum
% length based on the number of examples in each leaf node.
binary_predictions = zeros(size(x2,1),6);
counters = zeros(size(x2,1),6);

for i = 1:length(T)
    [pred, counter] = count_leaf_examples(T(i), x2);
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
        result(i) = randi([1,6]);        
    elseif(sum(binary_predictions(i,:)) == 1)
        for j = 1:6
            if binary_predictions(i,j) == 1
                result(i) = j;
            end
        end
    else
        % If there is more than one class that predict the example, 
        % Keep emotion in predictions and corresponding F1 in
        % f_a_candidates
        for j = 1:6
            if binary_predictions(i,j) == 1
                if (counters(i,j) < min_length)
                    min_length = rand(0,round(counters(i,j)*1000));
                    result(i) = j;
                end    
            end
        end
    end
end

end


function [ prediction_result, counter_result] = count_leaf_examples( tree, examples )
%Function that counts the number of examples in each leaf node, and returns
%both prediction as well as the sum of the count
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
         counter_result(row, 1) = tree.number_at_node;
    end  

end
