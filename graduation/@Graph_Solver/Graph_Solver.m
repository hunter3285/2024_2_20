classdef Graph_Solver < Path_Solver
    properties
        adjacency_matrix;
        edge_time;
        profit_col;
        node_number_matrix;
        all_rate_matrix;
        solved_col;
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
%         last_step_right_or_left
%         N_max_user
%         p_mean;
%         p_max;
%         p_min;
%         p_max_total
%         cell_matrix
%         N_iter
%         current_x;
%         current_y;
%         current_direction;
%         current_time;
    end
    methods
%         set_power_vec(obj, p)
%         set_turn_costs(obj, turn_cost_left, turn_cost_right)
%         set_sensing_matrices(obj, sensing_matrix_in, sensign_matrix_2_in)
%         rate=get_rate(obj, x,y, time)
%         set_channel_coef_matrix(obj, UAV_Solver_instance)
%         valid=check_direction(obj, point_to_check)
%         n_grid_count=count_n_grid(obj)
%         [step_with_time, last_step_turn, last_turn_right_or_left]...
%             = StepWithTimeSlot(obj, steps)
%         [rate, rate_vec]=get_correct_rate(obj)
%         power_parameters(obj)
%         power_optimization(obj)
%         set_cells(obj, UAV_Solver_instance)
%         record_result(obj)
%         BCD_for_pow_path(obj)
%         save_power(obj)
%         [x_right, y_right, x_straight, y_straight, x_left, y_left]=get_neighbor(obj)
%         [visited_if_right, visited_if_straight, visited_if_left]=get_current_visited(obj)
        set_edge_time(obj)
        solve_path(obj)
        function obj=Graph_Solver(UAV_Solver_instance)
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
            obj.visited_matrix=zeros(obj.N_cell_x, obj.N_cell_y);

            obj.N_max_user=UAV_Solver_instance.N_max_user;
            obj.p_max=UAV_Solver_instance.p_max;
            obj.p_min=UAV_Solver_instance.p_min;
            obj.p_mean=UAV_Solver_instance.p_mean;
            obj.p_max_total=UAV_Solver_instance.p_max_total;
            obj.N_iter=0;
            obj.last_step_right_or_left=0;

            obj.adjacency_matrix=zeros(obj.N_cell_x* obj.N_cell_y *4);
            obj.profit_col=zeros(obj.N_cell_x* obj.N_cell_y *4, 1);
            obj.edge_time=zeros(obj.N_cell_x* obj.N_cell_y*4 );
            obj.node_number_matrix=zeros(obj.N_cell_x, obj.N_cell_y, 4);
            obj.all_rate_matrix=UAV_Solver_instance.all_rate_matrix;
            obj.start=UAV_Solver_instance.start;

        end
    end
end