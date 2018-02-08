function [predictions,binary_prediction_set ] = testTrees(T, x2)

binary_prediction_set = zeros(size(x2,1),6);

for i = 1:length(T)
    pred = prediction(T(i), x2);
    binary_prediction_set(:,i) = pred;
    
    %disp(binary_prediction_set);
    %noisy_binary = binary_targets(i, x2);
    %accuracy = evaluate(pred, noisy_binary);
    %disp(accuracy);
end

predictions = combine_predictions(binary_prediction_set);

end

