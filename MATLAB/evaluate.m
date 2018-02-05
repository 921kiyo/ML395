function [accuracy] = evaluate(predictions, labels)

correct = 0;
length = size(predictions,1);

for i=1:length
    if predictions(i) == labels(i)
        correct = correct+1;
    end
end

accuracy = correct / length;

end

