function [overall_accuracy, overall_error, accuracy, recall, precision, f_1] = evaluate_metrics(predictions, labels, classes)

len = length(predictions);
recall = zeros(6,1);
precision = zeros(6,1);
accuracy = zeros(6,1);
f_1 = zeros(6,1);

TP_tot = 0;
FP_tot = 0;
TN_tot = 0;
FN_tot = 0;

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
    
    
TP_tot = TP_tot + TP;
FP_tot = FP_tot + FP;
TN_tot = TN_tot + TN;
FN_tot = FN_tot + FN;
    
end

overall_accuracy = (TP_tot+TN_tot)/(TP_tot+FP_tot+FN_tot+TN_tot);
overall_error = 1 - overall_accuracy;

end

