function [result] = testTrees4(T, x2)
% Function to comgine 6 trees based on pre-computed precision
% if no binary trees predict a class, we choose randomly
% if one binary tree predicts a class, we select that tree
% if >1 binary tree predicts a class, we select the tree with the highest
% precision score achieved during training (hardcoded)
binary_predictions = zeros(size(x2,1),6);

for i = 1:length(T)
    pred = prediction(T(i), x2);
    binary_predictions(:,i) = pred;
end

l = size(binary_predictions,1);

% Pre-computed precision for each emotion
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