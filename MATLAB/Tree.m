classdef Tree
    %UNTITLED8 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        op;
        kids = {};
        class;
        number_at_node;
    end
    
    methods
        function obj= Tree(op_,class_,number_at_node_)
            obj.op = op_;
            obj.class = class_;
            obj.number_at_node = number_at_node_;
        end
        
        
    end
    
end

