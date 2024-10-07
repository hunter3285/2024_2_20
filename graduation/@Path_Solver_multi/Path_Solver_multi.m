classdef Path_Solver_multi < handle
    properties
        N_UAV;
        Solver_row; % each is for one UAV
        last_step_turn_row; % indicate if the last step is a turn for each UAV
        last_turn_right_or_left_row; % indicate if the last step is a left-turn or a right-turn for each UAV
        UAVs_step_with_time; % all_step_with_time for each UAV, each is a row
        UAV_rate_row;
        N_cell_x;
        N_cell_y;
        start;
        mean_rate;
        fixed_sensing_matrix;
        fixed_sensing_matrix_2;
        % because in BCD_for_UAV_paths (for DP),
        % we set sensing matrices to solve each path
        % 'fixed' here means its not for the same purpose as above
        % but these matrices are the from the setting of the original problem
        % e.g., some cells we don't want to visit
        N_max=15;
    end
    methods
        all_step = eliminate_same_steps(obj, step_with_time_slot)
        rate=get_total_rate(obj)
        [total_visited, total_visited_2]=get_total_visited(obj, target_UAV_idx)
        set_cells(obj, UAV_Solver_inst)
        function obj=Path_Solver_multi()
        end
 
    end
end