% Reference: https://uk.mathworks.com/help/matlab/matlab_oop/creating-object-arrays.html
classdef ObjectArray
    %TREESARRAY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Value
    end
    
    methods
        function obj = ObjectArray(F)
            m = size(F,1);
            n = size(F,2);
            obj(m, n) = ObjectArray;
            for i = 1:m
                for j = 1:n
                    obj(i,j).Value = F(i,j);
                end
            end
        end
    end
    
end

