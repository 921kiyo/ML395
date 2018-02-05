function [ tree_set ] = tree_set_gen(examples, attributes, labels)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
tree_set = {};
for tree = 1:max(labels)
   binary_targets_collection = binary_targets(tree, labels);
   new_tree = DECISION_TREE_LEARNING(examples, attributes, binary_targets_collection);
   tree_set = [tree_set, new_tree];
end    
   
end

