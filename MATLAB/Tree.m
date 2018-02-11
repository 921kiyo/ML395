classdef Tree
    %Class definition for Tree of three properties and recursive call for
    %generating subtrees
    
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

