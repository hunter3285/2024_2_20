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
        coef_vec_cell_matrix;
        noise_variance;
        N_user_matrix;
        sum_rate;
        visited_matrix;
        visited_indicator_matrix;           % if direction==0||direction==2
        visited_indicator_matrix_2;         % if direction==1||direction==3
        rate_vec;
        last_step_turn;
        last_step_right_or_left; 
        N_max_user;
        p_mean;
        p_max;
        p_min;
        p_max_total;
        % parameters gained after having a path
        step_coef_matrix;
        step_N_user_max;
        step_noise_variance_matrix;
        step_N_user_vec;
        % parameters gained after having power optimization
        rate_after_power_opt;
        % parameters for remembering last result
        all_step_old;           % set in record_result
        visited_matrix_old;     % set in record_result
        sum_rate_old;           % set in record_result
        n_grid_old;             % set in record_result
        N_iter;
        power_vec_old;          % set in save_power
        % parameter for remerbering BCD result
        BCD_rate_row;

        current_x;
        current_y;
        current_direction;
        current_time;
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
        [rate, rate_vec]=get_correct_rate(obj)
        power_parameters(obj)
        power_optimization(obj)
        set_cells(obj, UAV_Solver_instance)
        record_result(obj)
        BCD_for_pow_path(obj)
        save_power(obj)
        [x_right, y_right, x_straight, y_straight, x_left, y_left]=get_neighbor(obj)
        [visited_if_right, visited_if_straight, visited_if_left]=get_current_visited(obj)
    end
end