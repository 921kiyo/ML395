% Script to create a decision tree (or tree set) and plot it.
data = load('Data/cleandata_students.mat');   
examples = data.x;
attributes = transpose(1:size(examples,2));
y = data.y;
n_classes = 6;

for emotion= 6:n_classes
    % Train tree on emotion
    labels = binary_targets(emotion, y);
    t = DECISION_TREE_LEARNING(examples, attributes, labels);

    % Get vector of node positions and corresponding attribute values from
    % the tree
    [nodes, labs] = tree_nodes(t, 0);

    % Plot the tree:
    hFigure = figure('Color','w');
    hAxes = axes('Parent',hFigure,'YColor','w','LineWidth',2);
    hAxes.Visible = 'off';
    
    %xlim([0.1 0.8])
    %ylim([0 10])

    x_nodes = [];
    y_nodes = [];
    % Add node labels
    [x,y] = treelayout(nodes);

    hold on
    for i=1:length(labs)    
        [y1,y2,x2] = get_node_position(nodes,x,i);

        if i > 1
            plot(hAxes,[x(i),x2],[y1,y2]);
        end
        y_nodes = [y_nodes,y1];
    end

    plot(hAxes,x,y_nodes,'o','MarkerFaceColor',[0.96 0.96 0.86],...
          'MarkerSize',15,'MarkerEdgeColor','k','LineWidth',1);

    for i=1:length(labs)    
        [y1,y2,x2] = get_node_position(nodes,x,i);

        if labs(i) == -1
             t = text(hAxes,x(i),y1,'T');
             t.FontWeight = 'bold';
        elseif labs(i) == -2
             t = text(hAxes,x(i),y1,'F');
             t.FontWeight = 'bold';
        else
            t = text(hAxes,x(i),y1,num2str(labs(i)));
        end
        t.HorizontalAlignment='center';
    end

    hold off    
    print(num2str(emotion),'-depsc')
    
end
