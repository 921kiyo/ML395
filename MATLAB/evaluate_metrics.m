function [overall_accuracy, accuracy, recall, precision, f_1] = evaluate_metrics(predictions, labels, classes)

len = length(predictions);
recall = zeros(6,1);
precision = zeros(6,1);
accuracy = zeros(6,1);
f_1 = zeros(6,1);

for class=1:classes
    
    TP = 0;
    FP = 0;
    TN = 0;
    FN = 0;
    
    for i = 1:len
        if predictions(i) == class && labels(i) == class
           TP = TP + 1;
        elseif predictions(i) == class && labels(i) ~= class
           FP = FP + 1;  
        elseif predictions(i) ~= class && labels(i) ~= class
            TN = TN+1;
        elseif predictions(i) ~= class && labels(i) == class
           FN = FN + 1; 
        end
    end
    
    accuracy(class) = (TP+TN)/(TP+FP+FN+TN);
    recall(class) = TP/(TP+FN);
    precision(class) = TP/(TP+FP);
    f_1(class) = 2*(recall(class)*precision(class))/(recall(class)+precision(class));
    
end
overall_accuracy = sum(predictions == labels)/len;

end

