function [y1,y2,x2 ] = get_node_position( nods,x,index )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    count = 0;
    current = index;
    depth = 0;
    
    while current ~= 0
        current = nods(current);
        if count == 0 && index ~= 1
            disp(current)
            x2 = x(current);
        elseif index == 1
            x2 = x(1);
        end
        depth = depth +1;
        count = count+1;
    end
    y1 = 10-depth * 0.1;
    y2 = 10-(depth-1)*0.1;
    
    disp(x2)
end

