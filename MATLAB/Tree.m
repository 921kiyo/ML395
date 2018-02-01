classdef Tree
    %UNTITLED8 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        op;
        kids = {};
        class;   
    end
    
    methods
        function obj= Tree(op_,class_)
            obj.op = op_;
            obj.class = class_;
        end
    end
    
end

