% Create a small tree and plot it
data = load('Data/cleandata_students.mat');
noisy_data = load('Data/noisydata_students.mat');
noisy_examples = noisy_data.x;
noisy_y = noisy_data.y;    
examples = data.x;
attributes = transpose(1:size(examples,2));
y = data.y;
n = 100;
examples_sub = examples(1:n,:);
y_sub = y(1:n,:);

emotion = 4;
binary_sub = binary_targets(emotion, y_sub);
t = DECISION_TREE_LEARNING(examples_sub, attributes,  binary_sub);
preds = prediction(t, noisy_examples);
noisy_binary = binary_targets(emotion, noisy_y);
acc = evaluate(preds, noisy_binary);
disp(acc);
display_tree(t);

