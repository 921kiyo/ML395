function [result] = combine_predictions(binary_predictions)
% Convert set of predictions to an integer overall result

l = size(binary_predictions,1);

result = zeros(l,1);

% combining the trees:
for i = 1:l
    % i.e no trees predict that the example has the emotion
    if(sum(binary_predictions(i,:)) == 0)
        % arbitrarily choose the first emotion
        result(i) = 1;        
    else
        for j = 1:6
            if binary_predictions(i,j) == 1
                result(i) = j;
            end
        end
    end
end


                    
        




end

