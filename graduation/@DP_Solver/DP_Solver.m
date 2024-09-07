classdef DP_Solver < Path_Solver
    properties
        dp_matrix;
        last_step_matrix;
        visited_cells_matrix;
        visited_cells_matrix_2;
        % below are parameters inherited from Path_Solver
%         N_cell_x;
%         N_cell_y;
%         sensing_matrix;
%         sensing_matrix_2;
%         obstacle_matrix;
%         time_slot_max;
%         start;
%         turn_cost_right;
%         turn_cost_left;
%         all_step;
%         all_step_with_time;
%         power_vec;
%         n_grid;
%         mean_rate;
%         channel_coef_matrix;
%         noise_variance;
%         N_user_matrix;
%         sum_rate;
%         visited_matrix;
%         visited_indicator_matrix;
%         visited_indicator_matrix_2;
%         rate_vec;
%         last_step_turn
    end
    methods
        clear(obj)
        [max_profit, max_index]=dp_main(obj)
        [profit]=dp_rec(obj, x, y, direction, time)
        [sum_rate_optimal_dp, visited_dp, visited_temp, visited_temp_2,...
            all_step_dp, last_step_matrix, dp_matrix, n_grid, rate_vec]=...
            get_dp_result(obj)
        function obj=DP_Solver(UAV_Solver_instance)
            obj.N_cell_x=UAV_Solver_instance.N_cell_x;
            obj.N_cell_y=UAV_Solver_instance.N_cell_y;
            obj.sensing_matrix=UAV_Solver_instance.sensing_matrix;
            obj.sensing_matrix_2=UAV_Solver_instance.sensing_matrix_2;
            obj.obstacle_matrix=UAV_Solver_instance.obstacle_matrix;
            obj.time_slot_max=UAV_Solver_instance.time_slot_max;
            obj.start=UAV_Solver_instance.start;
            obj.set_turn_costs(UAV_Solver_instance.turn_cost_left, ...
                UAV_Solver_instance.turn_cost_right);
            obj.set_power_vec(UAV_Solver_instance.power_initial_vec);
            obj.noise_variance=UAV_Solver_instance.noise_variance;
            obj.mean_rate=UAV_Solver_instance.mean_rate;
            obj.N_user_matrix=UAV_Solver_instance.N_user_matrix;
            obj.set_channel_coef_matrix(UAV_Solver_instance);
            obj.dp_matrix=-1*ones(obj.N_cell_x, obj.N_cell_y, ...
                4, obj.time_slot_max+1);
            obj.last_step_matrix=-1*ones(obj.N_cell_x, obj.N_cell_y,...
                4, obj.time_slot_max+1,4);
            obj.visited_cells_matrix=zeros(obj.N_cell_x, obj.N_cell_y, ...
                4, obj.time_slot_max+1, obj.N_cell_x*obj.N_cell_y);
            obj.visited_cells_matrix_2=zeros(obj.N_cell_x, obj.N_cell_y, ...
                4, obj.time_slot_max+1, obj.N_cell_x*obj.N_cell_y);
        end
    end
end