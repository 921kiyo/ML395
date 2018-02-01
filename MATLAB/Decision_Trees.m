data = load('Data/cleandata_students.mat');

examples = data.x;
attributes = transpose(1:size(examples,2));
y = data.y;



%Create the binary targets for an emotion
val = 3;
binary = binary_targets(val,y);

tree = DECISION_TREE_LEARNING(examples,attributes,binary);

view(tree,kids)