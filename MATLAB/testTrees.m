function [predictions] = testTrees(T, x2)
% Test trees using random assignment of classes
% to resolve conflicting positives from underlying trees
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
    % i.e no trees predict that the example has the emotion
    if(sum(binary_predictions(i,:)) == 0)
        % Choose a random number between 1 and the number of classes
        result(i) = randi([1,n_classes]);
        
        disp(i)
    elseif(sum(binary_predictions(i,:)) == 1)
        for j = 1:n_classes
            if binary_predictions(i,j) == 1
                result(i) = j;
            end
        end
    else
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
