function [predictions] = testTrees(T, x2)
% Function to comgine 6 trees based on random selection of an emotion when there is no/more than one binary trees.
% if no binary trees predict a class, we choose randomly
% if one binary tree predicts a class, we select that tree
% if >1 binary tree predicts a class, we choose randomly among these emotions.

n_trees = length(T);
binary_prediction_set = zeros(size(x2,1),n_trees);

for i = 1:length(T)
    pred = prediction(T(i), x2);
    binary_prediction_set(:,i) = pred;
end

predictions = combine_predictions(binary_prediction_set, n_trees);

end

function [result] = combine_predictions(binary_predictions, n_classes)
% Convert set of predictions to an integer overall result

l = size(binary_predictions,1);

result = zeros(l,1);

% Combining the trees:
for i = 1:l
    % If no trees predict that the example has the emotion
    if(sum(binary_predictions(i,:)) == 0)
        % Choose a random number between 1 and the number of classes
        result(i) = randi([1,n_classes]);
    elseif(sum(binary_predictions(i,:)) == 1)
        for j = 1:n_classes
            if binary_predictions(i,j) == 1
                result(i) = j;
            end
        end
    else
    % If more than one class predict that the example has the emotion,
    % choose one emotion randomly among these emotions
        predictions = {};
        for j = 1:n_classes
            if binary_predictions(i,j) == 1
                predictions = [predictions, j];
            end
        end
        index = randi([1, numel(predictions)]);
        result(i) = cell2mat(predictions(index));
    end
end

end
