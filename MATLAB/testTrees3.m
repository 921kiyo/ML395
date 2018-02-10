function [ result ] = testTrees3(T, x2, targets)
%TESTTREES3 Summary of this function goes here
% if no binary trees predict a class, we choose randomly
% if one binary tree predicts a class, we select that tree
% if >1 binary tree predicts a class, we select the tree with the highest
% F1 score achieved during training (hardcoded)

binary_predictions = zeros(size(x2,1),6);

for i = 1:length(T)
    pred = prediction(T(i), x2);
    binary_predictions(:,i) = pred;
end

for i = 1:6
    classes = 1;
    bin_targets = binary_targets(i, targets);
    [overall_accuracy, accuracy, recall, precision, f_1] = evaluate_binary_metrics(binary_predictions(:,i), bin_targets, classes);
    disp(f_1);
end

% TODO: Hardcode f scores. When the trees are tested, they will have
% already been trained
f_1_array = [0.166, 0.167, 0.165, 0.168, 0.164, 0.169];

l = size(binary_predictions,1);

result = zeros(l,1);

% combining the trees:
for i = 1:l
    % i.e no trees predict that the example has the emotion
    if(sum(binary_predictions(i,:)) == 0)
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
        predictions = {};
        f_1_candidates = {};
        for k = 1:6
            if binary_predictions(i,k) == 1
                predictions = [predictions,k];
                f_1_candidates = [f_1_candidates, f_1_array(k)];
            end
        end
        
        if isa(cell2mat(f_1_candidates), 'double')
            f_1_candidates_double = cell2mat(f_1_candidates);
        end
          
        num_pred = numel(predictions);
        max_f1 = 0;
        best_discriminant = 0;
        for m = 1:num_pred;
            if max_f1 < f_1_candidates_double(m)
                best_discriminant = predictions(m);
                max_f1 = f_1_candidates_double(m);
            end
        end
        result(i) = cell2mat(best_discriminant);
    end
end

end