classdef abc < handle
    properties
        a
        b
        c=6;
    end
    methods
        function set_a(obj)
            obj.a=5;
            disp('in abc')
        end
    end
end