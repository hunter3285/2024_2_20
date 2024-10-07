classdef DP_Solver_multi < Path_Solver_multi
    properties
%         N_UAV
%         Solver_row;                   % each is for one UAV
%         last_step_turn_row;           % indicate if the last step is a turn for each UAV
%         UAVs_step_with_time;          % all_step_with_time for each UAV, each is a row
%         last_turn_right_or_left_row;  % indicate if the last step is a left-turn or a right-turn for each UAV
%         UAV_rate_row
%         N_cell_x;
%         N_cell_y;
%         start;
%         mean_rate;
%         fixed_sensing_matrix;
%         fixed_sensing_matrix_2;
%         N_max=15;

        total_sum_rate_row; % for recording sum_rate at each iteration
        
    end
    methods
        BCD_for_UAV_paths_DP(obj)
        get_comm_paths(obj)
%         all_step = eliminate_same_steps(obj, step_with_time_slot)
%         get_total_rate(obj)
%         [total_visited, total_visited_2]=get_total_visited(obj, target_UAV_idx)

        function obj=DP_Solver_multi(UAV_Solver_instance)
            obj.N_UAV=UAV_Solver_instance.N_UAV;
            Solver_row=[];
            for ii=1:obj.N_UAV
                Solver_row=[Solver_row, DP_Solver(UAV_Solver_instance)];
            end
            obj.Solver_row=Solver_row;
            obj.last_step_turn_row=zeros(1, obj.N_UAV);
            obj.last_turn_right_or_left_row=zeros(1, obj.N_UAV);
            obj.UAVs_step_with_time=zeros(obj.N_UAV*2, UAV_Solver_instance.time_slot_max);
            obj.UAV_rate_row=zeros(1, obj.N_UAV);
            obj.N_cell_x=UAV_Solver_instance.N_cell_x;
            obj.N_cell_y=UAV_Solver_instance.N_cell_y;
            obj.start=UAV_Solver_instance.start;
            obj.mean_rate=UAV_Solver_instance.mean_rate;
            obj.fixed_sensing_matrix=ones(obj.N_cell_x, obj.N_cell_y);
            obj.fixed_sensing_matrix_2=obj.fixed_sensing_matrix;
        end
 
    end
end