classdef Path_Solver < handle
    properties
        N_cell_x;
        N_cell_y;
        sensing_matrix;
        sensing_matrix_2;
        obstacle_matrix;
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
        sum_rate;
        visited_matrix;
        visited_indicator_matrix;
        visited_indicator_matrix_2;
        rate_vec;
        last_step_turn;
    end
    methods
        function obj=Path_Solver()
        end
        set_power_vec(obj, p)
        set_turn_costs(obj, turn_cost_left, turn_cost_right)
        set_sensing_matrices(obj, sensing_matrix_in, sensign_matrix_2_in)
        rate=get_rate(obj, x,y, time)
        set_channel_coef_matrix(obj, UAV_Solver_instance)
        valid=check_direction(obj, point_to_check)
        n_grid_count=count_n_grid(obj)
        [step_with_time, last_step_turn, last_turn_right_or_left]...
            = StepWithTimeSlot(obj, steps)
    end
end