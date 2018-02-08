function [result] = testTrees2(T, x2)

binary_predictions = zeros(size(x2,1),6);
counters = zeros(size(x2,1),6);

for i = 1:length(T)
%     pred = shortest_tree(T(i), x2)
    [pred, counter] = shortest_tree(T(i), x2);
    binary_predictions(:,i) = pred;
    counters(:,i) = counter;
end

l = size(binary_predictions,1);

result = zeros(l,1);

% combining the trees:
for i = 1:l
    min_length = -1;
    % i.e no trees predict that the example has the emotion
    if(sum(binary_predictions(i,:)) == 0)    
        % arbitrarily choose the first emotion
        result(i) = 1;        
    elseif(sum(binary_predictions(i,:)) == 1)
        for j = 1:6
            if binary_predictions(i,j) == 1
                result(i) = j;
            end
        end
    else
        for j = 1:6
            if binary_predictions(i,j) == 1
                if (min_length == -1) || (counters(i,j) < min_length)
                    min_length = counters(i,j);
                    result(i) = j;
                end    
            end
        end
    end
end

end

