classdef Path_Solver < handle
    properties
        N_cell_x;
        N_cell_y;
        sensing_matrix;
        sensing_matrix_2;
        time_slot_max;
        start;
        turn_cost_right;
        turn_cost_left;
        all_step;
        all_step_with_time;
        power_vec;
        n_grid;
        mean_rate;
        channel_coef_matrix;
        noise_variance;
        N_user_matrix;
    end
    methods
        function obj=Path_Solver(N_cell_x, N_cell_y, start, turn_cost_right, turn_cost_left)
            obj.N_cell_x=N_cell_x;
            obj.N_cell_y=N_cell_y;
            obj.start=start;
            obj.turn_cost_left=turn_cost_left;
            obj.turn_cost_right=turn_cost_right;
        end
        set_power_vec(p)
        set_turn_costs(turn_cost_left, turn_cost_right)
    end
end