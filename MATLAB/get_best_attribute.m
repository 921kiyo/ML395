function [best_attribute_] = get_best_attribute(examples_,attributes,binary)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    max_gain = 0; 
    best_attribute_ = 1;
    
    %disp(size(examples));
    for attr=1:size(attributes,1)
        %disp(attributes(attr));
       
        col = examples_(:,attributes(attr));
        p_1 = size(col(col==1 & binary == 1),1);
        n_1 = size(col(col==1 & binary == 0),1);
        p_0 = size(col(col==0 & binary == 1),1);
        n_0 = size(col(col==0 & binary == 0),1);
        
        gain = get_gain(p_1,n_1,p_0,n_0);
        
        if gain > max_gain
            max_gain = gain;
            best_attribute_ = attr;
        end
    end
    
    % Return the actual attribute not the index
    best_attribute_ = attributes(best_attribute_);
    
end

