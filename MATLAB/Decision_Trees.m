% Script to perform cross validation
% Generates evaluation metrics and confusion matrix for the report

data = load('Data/cleandata_students.mat');
%data = load('Data/noisydata_students.mat');

examples = data.x;
y = data.y;
attributes = transpose(1:size(examples,2));

%Set folds for validation and create tables to store data
N_folds = 10;

cv_total_accuracy = zeros(N_folds,1);
cv_individual_accuracy = zeros(N_folds,6);
cv_precision = zeros(N_folds,6);
cv_recall = zeros(N_folds,6);
cv_f1 = zeros(N_folds,6);
all_predictions = [];
all_labels = [];

% Generate indices for cross validation
len = length(examples);
partition = cvpartition(len, 'KFold', N_folds);

% Perform cross validation on N folds, storing evaluated data
for t=1:N_folds
    
    train_idx = partition.training(t);
    train_ex = examples(train_idx,:);
    train_lab = y(train_idx,:);
    
    test_idx = partition.test(t);
    test_ex = examples(test_idx,:);
    test_lab = y(test_idx,:);
    
    tree_set = tree_set_gen(train_ex, attributes, train_lab);
    
    tree_predictions = testTrees(tree_set, test_ex);
    [fold_total_acc, fold_individual_accuracy, fold_recall, fold_precision, fold_f1] = evaluate_metrics(tree_predictions, test_lab, 6);
    
    cv_total_accuracy(t,1) = fold_total_acc;
    cv_individual_accuracy(t,:) = fold_individual_accuracy;
    cv_recall(t,:) = fold_recall;
    cv_precision(t,:) = fold_precision;
    cv_f1(t,:) = fold_f1;
    
    all_predictions = [all_predictions; tree_predictions];
    all_labels = [all_labels; test_lab];
    
end

% Plot the confusion matrix on the combined predictions on the N tests sets
% made during cross validation (average confusion matrix).
confusion_matrix(all_predictions, all_labels, 6, 1);

