data = load('Data/cleandata_students.mat');

examples = data.x;
attributes = transpose(1:size(examples,2));
y = data.y;

% view(tree.kids)
num_emotion = 6;

K = 10;

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
        display(['Corss validation, folds ', num2str(index)])
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