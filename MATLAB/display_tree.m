function [] = display_tree(tree)

% Get vector of node positions from tree
[nod, labs] = tree_nodes(tree, 0);


% Plot tree
treeplot(nod)
% Add node labels
[x,y] = treelayout(nod);
for i=1:length(labs)
    text(x(i)+0.015,y(i),num2str(labs(i)));
end

end

