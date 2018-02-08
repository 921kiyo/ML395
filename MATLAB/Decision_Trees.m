    data = load('Data/noisydata_students.mat');
    %data = load('Data/noisydata_students.mat');
    
    examples = data.x;
    y = data.y;  
    attributes = transpose(1:size(examples,2));

    N_folds = 10;
    %Create tables of metrics to evaluate on each fold
    cv_total_accuracy = zeros(N_folds,1);
    cv_individual_accuracy = zeros(N_folds,6);
    cv_precision = zeros(N_folds,6);
    cv_recall = zeros(N_folds,6);
    cv_f1 = zeros(N_folds,6);
    len = length(examples);
    partition = cvpartition(len, 'KFold', N_folds);

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

    end


    %total_cv_precision = sum(cv_precision,1)/N_folds;
    %total_cv_accuracy = sum(cv_accuracy,1)/N_folds;
    %total_cv_recall = sum(cv_recall,1)/N_folds;
    %total_cv_f1 = sum(cv_f1,1)/10;

    %checks = [checks;sum(total_cv_accuracy)/6,total_acc_2];
    %csvwrite("data.csv",checks)
    

%disp("The percentage of data is: " )
%checks(:,3) = transpose(1:size(checks,1));
%plot(transpose(1:size(checks,1)),checks(:,1),transpose(1:size(checks,1)),checks(:,2))

tree_set = tree_set_gen(examples, attributes, y);
multi_class_predictions = testTrees3(tree_set, examples(901:end, :), 1);
% multi_class_predictions = testTrees(tree_set, noisy_examples);
% confusion_matrix(multi_class_predictions, noisy_y, 1);


%{
tree_set = tree_set_gen(examples(1:900,:), attributes, y(1:900,:));
multi_class_predictions = testTrees(tree_set, examples(901:end,:));
confusion_matrix(multi_class_predictions, y(901:end,:),1);

test_examples = examples(1:100,:);
test_labels = y(1:100,:);

examples = examples(101:end,:);
y = y(101:end,:);
%}



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