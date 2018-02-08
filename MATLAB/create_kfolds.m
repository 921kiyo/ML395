function clean_trees = create_kfolds(examples, attributes, binary)
    % hardcode 10 for now
    indices = crossvalind('KFold', size(examples,1), 10);
    for i = 0:10
        % hardcode 6 for now
%         for it = 1:6
%             examples_test = 
%             training_9_folds = 
%             binary_9_folds = 
%         end
    end

end