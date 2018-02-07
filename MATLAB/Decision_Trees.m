data= load('Data/cleandata_students.mat');
noisy_data = load('Data/noisydata_students.mat');

examples = data.x;
y = data.y;

noisy_examples = noisy_data.x;
noisy_y = noisy_data.y;    

attributes = transpose(1:size(examples,2));

tree_set = tree_set_gen(examples(1:900,:), attributes, y(1:900,:));
multi_class_predictions = testTrees(tree_set, examples(901:end,:));
confusion_matrix(multi_class_predictions, y(901:end,:),1);





test_examples = examples(1:100,:);
test_labels = y(1:100,:);

examples = examples(101:end,:);
y = y(101:end,:);


cv_accuracy = zeros(10,6);
cv_precision = zeros(10,6);
cv_recall = zeros(10,6);
cv_f1 = zeros(10,6);
len = length(examples);
partition = cvpartition(len, 'KFold', 10);
for t=1:partition.NumTestSets
    
    train_idx = partition.training(t);
    train_ex = examples(train_idx,:);
    train_lab = y(train_idx,:);
    
    test_idx = partition.test(t);
    test_ex = examples(test_idx,:);
    test_lab = y(test_idx,:);
    
    tree_set = tree_set_gen(train_ex, attributes, train_lab);
    tree_predictions = testTrees(tree_set, test_ex);
    [total_acc, total_error, fold_accuracy, fold_recall, fold_precision, fold_f1] = evaluate_metrics(tree_predictions, test_lab, 6);
    
    predictions_check = testTrees(tree_set, test_examples);
    [total_acc_check, total_error_check, fold_accuracy_check, fold_recall_check, fold_precision_check, fold_f1_check] = evaluate_metrics(predictions_check, test_labels, 6);
    
    cv_accuracy(t,:) = fold_accuracy;
    cv_recall(t,:) = fold_recall;
    cv_precision(t,:) = fold_precision;
    cv_f1(t,:) = fold_f1;
    
end




%disp("CHECK")
%preds = prediction(tree, noisy_examples);
%acc2 = evaluate(preds, noisy_binary);
%disp(acc2)

%res = testTrees(tree_set, examples);

%{
%         trees = 1:num_emotion;
%      trees = Tree.empty(0,num_emotion);
%           trees = {};
% vector = zeros(6,10);
% trees = ObjectArray(vector);
predictions = zeros(6,10);
% example_folds = cvpartition.empty(1,K);
% binary_folds = cvpartition.empty(1,K);
for emotion = 1:num_emotion
    %Create the binary targets for an emotion
    binary = binary_targets(emotion,y);
    example_fold = cvpartition(size(examples, 1),'KFold', K);
    binary_fold = cvpartition(size(binary, 1),'KFold', K);

    for index = 1:K
        display(['Cross validation, fold ', num2str(index)])
        % Splitting data into training and testing sets
        examples_training_idx = example_fold.training(index);
        examples_test_idx = example_fold.test(index);
        examples_9_fold = examples(examples_training_idx, :);
        examples_test = examples(examples_test_idx,:);

        binary_training_idx = binary_fold.training(index);
        binary_test_idx = binary_fold.test(index);
        binary_9_fold = binary(binary_training_idx, :);
        binary_test = binary(binary_test_idx,:);
        
%         for e = 1:num_emotion
        tree = DECISION_TREE_LEARNING(examples_9_fold, attributes, binary_9_fold);
%         prediction_result = prediction(tree, );
        prediction_result = prediction(tree, examples_test);
        predictions(emotion, index) = prediction_result;
        
    end
end

%}