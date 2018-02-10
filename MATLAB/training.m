% Script to perform cross validation
% Generates evaluation metrics and confusion matrix for the report
% data = load('Data/cleandata_students.mat');
data = load('Data/cleandata_students.mat');
examples = data.x;
y = data.y;

% noisy_data = load('Data/cleandata_students.mat');
% noisy_data = load('Data/cleandata_students.mat');
% noisy_examples = noisy_data.x;
% noisy_y = noisy_data.y;

attributes = transpose(1:size(examples,2));

tree_set = tree_set_gen(examples, attributes, y);
