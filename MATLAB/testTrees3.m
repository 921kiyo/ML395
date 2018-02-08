function [ result ] = testTrees3( binary_target, binary_predictions )
%TESTTREES3 Summary of this function goes here
%   Detailed explanation goes here
classes = [0 1];
f_1_array = zeros(1,6);

for i = 1:6
   [overall_accuracy, accuracy, recall, precision, f_1] = evaluate_metrics(binary_predictions, binary_target, classes);
   f_1_array(1,i) = f_1; 
end

l = size(binary_predictions,1);

result = zeros(l,1);

% combining the trees:
for i = 1:l
    % i.e no trees predict that the example has the emotion
    if(sum(binary_predictions(i,:)) == 0)
        % Choose the common emotion from the training
        % TODO rather than the maximum F1
%         result(i) = max(f_1_array);
    elseif(sum(binary_predictions(i,:)) == 1)
        for j = 1:6
            if binary_predictions(i,j) == 1
                result(i) =j;
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
                predictions = [[predictions, f_1_candidates], j];
                % Store both predictions and F1 in [[pred1, F1_1], [pred2,
                % F1_2] ...] 
            end
        end
        length = size(predictions, 1);
        max_f1 = 0;
        for i = 1:length
            if max_f1 < predictions(i, 2)
                % Store [emotion, F1]
                max_f1 = [predictions(i, 1), predictions(i, 2)];
            end
        end
        result(i) = max_f1(1,2);
    end
end

end

