function [confusion] = confusion_matrix(predictions, labels, normalize)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
l = length(predictions);
confusion = zeros(6,6);
for i=1:6
    for j = 1:6
        n = 0;
        for k=1:l
            if((labels(k) == i) && (predictions(k) == j))
                n = n+1;
            end
        end
        confusion(i,j) = n;
    end
end

h = heatmap(confusion);
%h.Colormap = col_map;
colorbar('off')

end

