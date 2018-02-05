function [ prediction_result ] = prediction( tree, examples )
%PREDICTION Summary of this function goes here
%   Detailed explanation goes here
 
    root = tree;
    disp(tree);
    i = 1;
    prediction_result = int16.empty(0,1);
    
    for row = 1:size(examples, 1)
        tree = root;
        % While we still have subtrees

         while ~isempty(tree.class)
%              tree = tree.kids(1);
             % if the example is negative for the root attribute, choose
             % the first subtree
%              size(examples)
             disp("before");
             disp(tree(1).class);
             disp("after");
             if tree(1).class == -1
                 tree = tree(1).kids;
             else
                 tree = tree(2).kids;
%              examples(i, tree.op);
%                if(examples(i, tree.op)) == -1
%                    tree = tree.kids(1);
%                else
%                    tree = tree.kids(2);
%                end
             end
         end
         prediction_result(row, 1) = tree.class;
         i = i + 1;
    end   
end

