classdef node < handle
    properties
        x
        y
        direction
        visited_state=0;
        % 0: not visited, 1: in the list, 2: visited
        cost=1e9;
        spent_time;
        last_x;
        last_y;
        last_direction;
    end

    methods
        function obj=node(x,y,direction)
            if nargin>0
                obj.x=x;
                obj.y=y;
                obj.direction=direction;
            end
        end
        function isLess = lt(obj1, obj2)
            isLess = obj1.cost < obj2.cost;
        end
    end

end