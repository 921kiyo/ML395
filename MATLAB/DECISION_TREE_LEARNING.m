function [ tree ] = DECISION_TREE_LEARNING( examples,attributes,binary_targets)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    if range(binary_targets) == binary_targets(1)
       tree = Tree(-1,binary_targets(1));
       return
    end
    
    if size(attributes,1) == 0
        majority_value = mode(binary_targets);
        tree = Tree(-1,majority_value);
        return
    end
    best_attribute = get_best_attribute(examples,attributes,binary_targets);
    tree = Tree(best_attribute,-1);
    
    for attribute_value=0:1
        consistent_examples = examples(examples(:,best_attribute) == attribute_value,:);
        consistent_targets = binary_targets(examples(:,best_attribute) == attribute_value,:);
        remaining_attributes = attributes(attributes ~= attributes(best_attribute));
        
%         disp(size(consistent_examples,2));
        
        if size(consistent_examples,1) == 0
            majority_value = mode(binary_targets);
            branch = Tree(-1,majority_value);
        else
            branch = DECISION_TREE_LEARNING(consistent_examples,remaining_attributes,consistent_targets);
        end
        tree.kids = [tree.kids,branch];
    end
end

