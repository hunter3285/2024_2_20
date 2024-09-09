function BCD_for_UAV_paths(obj)
    for ii=1:obj.N_UAV
        disp(['Now is UAV',num2str(ii)]);
        DP_Solver_inst=obj.Solver_row(ii); % DP_Solver
        [total_visited, total_visited_2]=obj.get_total_visited(ii);
        
        sensing_matrix=mod(total_visited+1,2)
        sensing_matrix_2=mod(total_visited_2+1,2)
        DP_Solver_inst.set_sensing_matrices(sensing_matrix, sensing_matrix_2)

        [sum_rate, ~, ~, ~,  all_step, ~, ~, n_grid, ~]=DP_Solver_inst.get_dp_result;
        

        n_grid_count=DP_Solver_inst.count_n_grid();
        if DP_Solver_inst.n_grid~=n_grid_count
            disp('error in BCD_for_UAV_paths n_grid');
            n_grid_count
            n_grid
        end

        


        DP_Solver_inst.power_parameters;
        DP_Solver_inst.power_optimization;
        gain_after_power_opt_class=DP_Solver_inst.rate_after_power_opt+n_grid*DP_Solver_inst.mean_rate-sum_rate
        DP_Solver_inst.record_result();
        DP_Solver_inst.clear();
        [sum_rate_optimal_dp_class, ~, ~, ~,  ~, ~, ~, ~, ...
            ~]=DP_Solver_inst.get_dp_result();



        DP_Solver_inst.BCD_for_pow_path();
        [all_step_with_time, last_step_turn, last_turn_right_or_left]=DP_Solver_inst.StepWithTimeSlot();

        obj.last_step_turn_row(ii)=last_step_turn;
        obj.last_turn_right_or_left_row(ii)=last_turn_right_or_left;
        obj.UAVs_step_with_time(2*(ii-1)+1:2*ii,:)=all_step_with_time;
        obj.UAV_rate_row(ii)=sum_rate_optimal_dp_class;
        obj.total_sum_rate_row(ii)=sum(obj.UAV_rate_row);


        
    end
end