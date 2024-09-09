% assume cell_matrix is done
s=Single_UAV_Solver;
if exist('cell_matrix', 'var')
    s.set_cells(cell_matrix);
end
s.initialize_DP_Solver();
d=s.Solver_row(1);
[sum_rate_optimal_dp_class, visited_dp_class, visited_dp_class_temp, visited_dp_class_temp_2,  all_step_dp_class, ~, ~, n_grid_class, ...
    rate_vec_class]=d.get_dp_result;
%%
power_vec_class=d.power_vec;
mean_rate_class=s.mean_rate;
error_class=d.get_correct_rate()+n_grid_class*mean_rate_class-sum_rate_optimal_dp_class
%%
d.power_parameters();
d.power_optimization();
%%
gain_after_power_opt_class=d.rate_after_power_opt+n_grid_class*mean_rate_class-sum_rate_optimal_dp_class
%%
d.record_result();
d.clear();
[sum_rate_optimal_dp_class, visited_dp_class, visited_dp_class_temp, visited_dp_class_temp_2,  all_step_dp_class, ~, ~, n_grid_class, ...
    rate_vec_class]=d.get_dp_result();
d.BCD_for_pow_path();