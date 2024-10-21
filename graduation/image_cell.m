classdef image_cell < handle
    properties
        image
        image_x
        image_y
        image_horizontal
        image_x_horizontal
        image_y_horizontal
        scatterer_pos;
        
    end

    methods
        function obj=image_cell()
            

        end
        function set_N_azi(obj, N_azi)
            obj.image=zeros(N_azi, N_azi);
            obj.image_horizontal=zeros(N_azi, N_azi);
        end
    end

end