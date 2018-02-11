% Script to generate tree_set objects trained on the entire clean dataset
% Generates evaluation metrics and confusion matrix for the report
data = load('Data/cleandata_students.mat');
examples = data.x;
y = data.y;

attributes = transpose(1:size(examples,2));

tree_set = tree_set_gen(examples, attributes, y);
