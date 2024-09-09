classdef Path_Solver_multi < handle
    properties
        N_UAV;
        Solver_row; % each is for one UAV
        last_step_turn_row; % indicate if the last step is a turn for each UAV
        last_turn_right_or_left_row; % indicate if the last step is a left-turn or a right-turn for each UAV
        UAVs_step_with_time; % all_step_with_time for each UAV, each is a row
        UAV_rate_row;
    end
    methods
        function obj=Path_Solver_multi()
        end
 
    end
end