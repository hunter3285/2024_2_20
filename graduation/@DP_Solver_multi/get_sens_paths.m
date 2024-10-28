function get_sens_paths(obj)
for ii=1:obj.N_UAV
    disp(['Now is UAV ',num2str(ii)]);
    Solver_inst=obj.Solver_row(ii); % DP_Solver




    [total_visited, total_visited_2]=obj.get_total_visited(ii);
    
    sensing_matrix=mod(total_visited+1,2);
    sensing_matrix=sensing_matrix.*obj.fixed_sensing_matrix;
    sensing_matrix_2=mod(total_visited_2+1,2);
    sensing_matrix_2=sensing_matrix_2.*obj.fixed_sensing_matrix_2;
    
    Solver_inst.set_sensing_matrices(sensing_matrix, sensing_matrix_2)
    Solver_inst.clear_dp();


    [sum_rate_optimal_dp_class, ~, ~, ~,  ~, ~, ~, ~, ~]=Solver_inst.get_dp_result();
    [all_step_with_time, last_step_turn, last_turn_right_or_left]=Solver_inst.StepWithTimeSlot();
    Solver_inst.coef_vec_cell_matrix=obj.fixed_coef_vec_cell_matrix;
    Solver_inst.power_parameters;
    Solver_inst.power_optimization;
    %%上面求完了path，再把參數設定回來計算結果
    Solver_inst.sensing_matrix=obj.fixed_sensing_matrix;
    Solver_inst.sensing_matrix_2=obj.fixed_sensing_matrix_2;
    Solver_inst.coef_vec_cell_matrix=obj.fixed_coef_vec_cell_matrix;
    obj.last_step_turn_row(ii)=last_step_turn;
    obj.last_turn_right_or_left_row(ii)=last_turn_right_or_left;
    obj.UAVs_step_with_time(2*(ii-1)+1:2*ii,:)=all_step_with_time;
    obj.UAV_rate_row(ii)=Solver_inst.count_n_grid*obj.mean_rate+Solver_inst.get_correct_rate;
    obj.total_sum_rate_row(ii)=sum(obj.get_total_rate);
end