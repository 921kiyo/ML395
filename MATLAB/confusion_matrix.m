function [confusion] = confusion_matrix(predictions, labels, classes, normalize)
% Function to create a plot of a confusion matrix, and return the
% underlying matrix.

l = length(predictions);
confusion = zeros(classes);

% Iterate over matrix cells
for i=1:classes
    for j = 1:classes
        n = 0;
        % Count how many examples contribute to the cell
        for k=1:l
            if((labels(k) == i) && (predictions(k) == j))
                n = n+1;
            end
        end
        confusion(i,j) = n;
    end
    
    % Normalise across row if specified
    if(normalize)
        row_total = sum(confusion(i,:));
        for r=1:classes
            confusion(i,r) = round(confusion(i,r)/row_total,2);
        end
    end
end

% Create a heatmap representing the confusion matrix
h = heatmap(confusion);
xlabel('Predicted Class')
ylabel('Actual Class')
colorbar('off')

end

