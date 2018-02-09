function [ tree_set ] = tree_set_gen(examples, attributes, labels)
% Function to generate a set of trees corresponding to each label
tree_set = {};
for tree = 1:max(labels)
    binary_targets_collection = binary_targets(tree, labels);
    new_tree = DECISION_TREE_LEARNING(examples, attributes, binary_targets_collection);
    tree_set = [tree_set, new_tree];
end

end

