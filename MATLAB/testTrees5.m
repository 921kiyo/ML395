function [result] = testTrees5(T, x2)

binary_predictions = zeros(size(x2,1),6);

for i = 1:length(T)
    pred = count_examples(T(i), x2);
    binary_predictions(:,i) = pred;
end

l = size(binary_predictions,1);
precisions = [0.745109474289041,0.782458321492848,0.854413364413365,0.879639140844163,0.714700577200577,0.838587399606890];

result = zeros(l,1);

% combining the trees:
for i = 1:l
    max_f = 0;
    index = 0;
    % i.e no trees predict that the example has the emotion
    if(sum(binary_predictions(i,:)) == 0)    
        % arbitrarily choose a random emotion
        result(i) = randi([1,6]);        
    else
        for j = 1:6
            if binary_predictions(i,j) == 1
                if(precisions(j) > max_f)
                    max_f = rand(0,round(precisions(j)*1000));
                    index = j;
                end
            end
        end
        result(i) = index;
    end
end
end


function [ prediction_result] = count_examples( tree, examples )
%SHORTEST_TREE Summary of this function goes here
%   Detailed explanation goes here
    root = tree;
    len_examples = size(examples, 1);
    prediction_result = transpose(1:len_examples);

    for row = 1:len_examples
        tree = root;
        % While we still have subtrees
         while tree.op ~= -1
             tree = tree.kids(examples(row,tree.op)+1);
         end
         prediction_result(row,1) = tree.class;
%          prediction_result(row,2) = counter;
    end  

end
