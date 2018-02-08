% Create a small tree and plot it
data = load('Data/cleandata_students.mat');   
examples = data.x;
attributes = transpose(1:size(examples,2));
y = data.y;
n = 1004;
examples_sub = examples(1:n,:);
y_sub = y(1:n,:);

emotion = 3;
binary_sub = binary_targets(emotion, y_sub);
t = DECISION_TREE_LEARNING(examples_sub, attributes,  binary_sub);
display_tree(t);

