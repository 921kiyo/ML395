% Script to run testTree functions on tree objects trained on the entire clean dataset.
data = load("Data/cleandata_students.mat");
tree_set = load("MATLAB/tree_set.mat");
x = data.x;
y = data.y;

n_classes = 6;
normalize = 1;

predictions = testTrees4(tree_set.tree_set, x);
confusion_matrix_ = confusion_matrix(predictions, y,  n_classes, 1);