% Script to perform cross validation
% Generates evaluation metrics and confusion matrix for the report
data = load('Data/cleandata_students.mat'); % 'Data/noisydata_students.mat'
examples = data.x;
y = data.y;

noisy_data = load('Data/noisydata_students.mat');
noisy_examples = noisy_data.x;
noisy_y = noisy_data.y;

attributes = transpose(1:size(examples,2));

%Set folds for validation and create tables to store data
n_folds = 10;
n_classes = 6;

cv_total_accuracy = zeros(n_folds,1);
cv_individual_accuracy = zeros(n_folds,n_classes);
cv_precision = zeros(n_folds, n_classes);
cv_recall = zeros(n_folds, n_classes);
cv_f1 = zeros(n_folds, n_classes);
all_predictions = [];
all_labels = [];

% Generate indices for cross validation
len = length(examples);
partition = cvpartition(len, 'KFold', n_folds);

% Perform cross validation on N folds, storing evaluated data
for t=1:n_folds
    % Get training set for fold
    train_idx = partition.training(t);
    train_ex = examples(train_idx,:);
    train_lab = y(train_idx,:);
    % Get test set for fold
    test_idx = partition.test(t);
    test_ex = examples(test_idx,:);
    test_lab = y(test_idx,:);
    
    % Train tree set
    tree_set = tree_set_gen(train_ex, attributes, train_lab);
    % Predict on test set
    tree_predictions = testTrees(tree_set, test_ex);
    % Evaluate prediction metrics
    [fold_total_acc, fold_individual_accuracy, fold_recall, fold_precision, fold_f1] = evaluate_metrics(tree_predictions, test_lab, n_classes);
    % Store results from fold
    cv_total_accuracy(t,1) = fold_total_acc;
    cv_individual_accuracy(t,:) = fold_individual_accuracy;
    cv_recall(t,:) = fold_recall;
    cv_precision(t,:) = fold_precision;
    cv_f1(t,:) = fold_f1;
    
    all_predictions = [all_predictions; tree_predictions];
    all_labels = [all_labels; test_lab];

end

%Create average confusion matrix over cross validation
normalize = 1;
confusion_matrix(all_predictions, all_labels, n_classes, normalize);

%Generate values for report:
%Averages
report_accuracy = mean(cv_total_accuracy);
report_error_set = (1 - cv_total_accuracy);
report_error = mean(report_error_set);

%Errors
report_accuracy_conf = 1.96 * std(cv_total_accuracy)/ sqrt(n_folds);
report_error_conf = 1.96 * std(report_error_set)/ sqrt(n_folds);

%Recall, Precision, F_1 by emotion:
report_recall = mean(cv_recall);
report_precision = mean(cv_precision);
report_f1 = mean(cv_f1);

% END
    
