function [] = display_tree(tree)

% Get vector of node positions from tree
[nod, labs] = tree_nodes(tree, 0);


% Plot tree

treeplot(nod)
%dendrogram(nod)
% Add node labels

[x,y] = treelayout(nod);

disp(nod)
disp(labs)
%{
for i=1:(length(labs)-1)
   line([(50*x(i))+0.015,(50*x(i+1))+0.015],[y(i),y(i+1)]);
end
%}

hFigure = figure('Color','w');
hAxes = axes('Parent',hFigure,'YColor','w','LineWidth',2);
plot(hAxes,(50*x)+0.015,y,'o','MarkerFaceColor',[0.96 0.96 0.86],...
      'MarkerSize',15,'MarkerEdgeColor','k','LineWidth',1);

for i=1:length(labs)
   t = text(hAxes,(50*x(i))+0.015,y(i),num2str(labs(i)));
   t.HorizontalAlignment='center';
end










%{
treeplot(nod)
% Add node labels

[x,y] = treelayout(nod);
plot(x+0.015, y, 'o',8);
for i=1:length(labs)
    text(x(i)+0.015,y(i),num2str(labs(i)));
    
end

%}

end

