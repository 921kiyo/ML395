function [result] = combine_predictions(binary_predictions)
% Convert set of predictions to an integer overall result

l = size(binary_predictions,1);

result = zeros(l,1);

% combining the trees:
for i = 1:l
    % i.e no trees predict that the example has the emotion
    if(sum(binary_predictions(i,:)) == 0)
        % Choose a random number between 1 and 6
        result(i) = randi([1,6]);
    elseif(sum(binary_predictions(i,:)) == 1)
        for j = 1:6
            if binary_predictions(i,j) == 1
                result(i) =j;
            end
        end
    else
        predictions = {};
        for j = 1:6
            if binary_predictions(i,j) == 1
                predictions = [predictions, j];
            end
        end
        index = randi([1, numel(predictions)]);
        result(i) = cell2mat(predictions(index));
    end
end

end

