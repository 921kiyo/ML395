function [prediction_set] = testTrees_pert(T, x2)
% Number of permutations of the input example to make
number_repeats = 120;
% Max number of attributes to change
nf = 8;
% Initialise variables
n_trees = length(T);
attributes = size(x2,2);
prediction_set = zeros(size(x2,1),1);
agg_pred_set = zeros(size(number_repeats,1),n_trees);
n_examples = length(x2);

% Loop through the examples predicting each one
for n=1:n_examples
    % Create permutations of the example
    for k= 1:number_repeats
        example = x2(n,:);
        number_flips = randi(nf);
        indexes = randperm(attributes);
        example(indexes(1:number_flips)) = 2-randi(2);

        for i = 1:length(T)
            pred = prediction(T(i), example);
            agg_pred_set(k,i) = pred;
        end
    end
    % Find the emotion with the highest count
    res = sum(agg_pred_set);
    [val, emot] = max(res);
    
    % Set prediction to emotion with highest count
    prediction_set(n) = emot;
end
% Return prediction
end
