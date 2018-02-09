function [ result ] = testTrees3(T, x2)
%TESTTREES3 Summary of this function goes here
%   Detailed explanation goes here
% classes = [0 1];
% f_1_array = zeros(1,6);
% 
% for i = 1:6
%    [overall_accuracy, accuracy, recall, precision, f_1] = evaluate_metrics(binary_predictions, binary_target, classes);
%    

% end



binary_predictions = zeros(size(x2,1),6);

for i = 1:length(T)
    pred = prediction(T(i), x2);
    binary_prediction(:,i) = pred;
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
        % Choose the common emotion from the training
        % TODO rather than the maximum F1
%         result(i) = max(f_1_array);
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
        for j = 1:6
            if binary_predictions(i,j) == 1
                predictions = [predictions,j];
                f_1_candidates = [f_1_candidates, f_1_array(j)];
                % Store both predictions and F1 in [[pred1, F1_1], [pred2,
                % F1_2] ...] 
            end
        end
        num_pred = numel(predictions);
        max_f1 = 0;
        best_discriminant = 0;
        for i = 1:num_pred;
            if max_f1 < f_1_candidates(i)
                best_discriminant = i;
                max_f1 = f_1_candidates(i);
            end
        end
        result(i) = best_discriminant;
    end
end

end

