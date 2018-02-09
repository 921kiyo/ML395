function [best_attribute_] = best_attribute(examples,attributes,binary)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    max_gain = 0; 
    best_attribute_ = 0;
    
    for attr=1:size(attributes,2)
        col = examples(:,attributes(attr));
        p_1 = col(col==1 & binary == 1);
        n_1 = col(col==1 & binary == 0);
        p_0 = col(col==0 & binary == 1);
        n_0 = col(col==0 & binary == 0);    
        gain = get_gain(p_1,n_1,p_0,n_0);
        if gain > max_gain
            max_gain = gain;
            best_attribute_ = attr;
        end
    end
end


