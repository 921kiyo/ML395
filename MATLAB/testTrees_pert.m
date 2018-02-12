function [prediction_set] = testTrees_pert(T, x2,number_flips)
n_trees = length(T);
%h = waitbar(0,'Processing...');
prediction_set = zeros(size(x2,1),1);
number_repeats = 120;
agg_pred_set = zeros(size(number_repeats,1),n_trees);
number_flips = 4;
n_examples = length(x2);
for n=1:n_examples
    %waitbar(n/n_examples);
    % Set number of repeats
    for k= 1:number_repeats
        example = x2(n,:);
        
        indexes = randperm(44);
        example(indexes(1:number_flips)) = 2-randi(2);
        %{
        indexes = randperm(44);
        example(indexes(1:number_flips)) = 1;
        %}
        for i = 1:length(T)
            pred = prediction(T(i), example);
            agg_pred_set(k,i) = pred;
        end
    end
    % Find the column with the highest value
    res = sum(agg_pred_set);
    [val, emot] = max(res);
    
    prediction_set(n) = emot;
end
end
