classdef abcd < abc
    properties
        d
    end
    methods
        function obj=abcd()
            obj.d=5;
        end
        function set_a(obj)
            obj.a=15;
            disp('in abcd')
        end

    end
end