classdef UAV_cell
    properties
        user_locations%3*N matrix
        middle_point=zeros(3,1);
        user_distances;%1*N, distance to middle point
        channel;%Rician fading channel object
        noise_variance=0.01;
        snr_array=[];
        coef_array=[];
        sum_rate=0;
        N_user=0;
        N_scatterer=0;
        scatterer_pos
        image
        image_x
        image_y
        image_horizontal
        image_x_horizontal
        image_y_horizontal
%         new_cell_profit=0;
    end
end