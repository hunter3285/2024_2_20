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
    end
    methods
        function obj=DP_Solver(UAV_Solver_instance)
            obj.N_cell_x=UAV_Solver_instance.N_cell_x;
            obj.N_cell_y=UAV_Solver_instance.N_cell_y;
            obj.sensing_matrix=UAV_Solver_instance.sensing_matrix;
            obj.sensing_matrix_2=UAV_Solver_instance.sensing_matrix_2;
            obj.time_slot_max=UAV_Solver_instance.time_slot_max;
            obj.start=UAV_Solver_instance.start;
            obj.set_turn_costs(UAV_Solver_instance.turn_cost_left, ...
                UAV_Solver_instance.turn_cost_right);
            obj.set_power_vec(UAV_Solver_instance.power_vec);
        end
    end
end