function [prediction_set] = testTrees_pert(T, x2)
n_trees = length(T);
prediction_set = zeros(size(x2,1),1);
agg_pred_set = zeros(size(1000,1),n_trees);

n_examples = length(x2);
for n=1:n_examples
    
    % 1000 permutations
    for k= 1:50
        example = x2(n,:);
        pos = randi(44)+1;
        % Switch off a random attribute
        example(pos) = 0;
        pos = randi(44)+1;
        % Switch off another random attribute
        example(pos) = 0;
        pos = randi(44)+1;
        % Switch off another random attribute
        example(pos) = 0;
        
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
