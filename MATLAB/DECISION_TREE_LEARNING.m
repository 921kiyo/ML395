function [tree] = DECISION_TREE_LEARNING( examples,attributes,binary_targets_)
% Function to implement decision tree algorithm described in PartII
    if range(binary_targets_) == 0
       tree = Tree(-1,binary_targets_(1),length(binary_targets_));
       return
    end
    if size(attributes,1) == 0
        majority_value = mode(binary_targets_);
        tree = Tree(-1,majority_value,length(binary_targets_(binary_targets_== majority_value)));
        return
    end

    best_attribute = get_best_attribute(examples,attributes,binary_targets_);
    tree = Tree(best_attribute,-1,-1);

    for attribute_value=0:1
        consistent_examples = examples(examples(:,best_attribute) == attribute_value,:);
        consistent_targets = binary_targets_(examples(:,best_attribute) == attribute_value,:);
        remaining_attributes = attributes(attributes ~= best_attribute);
        if size(consistent_examples,1) == 0
            majority_value = mode(binary_targets_);
            branch = Tree(-1,majority_value,length(binary_targets_(binary_targets_==majority_value)));
        else
            branch = DECISION_TREE_LEARNING(consistent_examples,remaining_attributes,consistent_targets);
        end
        tree.kids = [tree.kids,branch];
    end
end