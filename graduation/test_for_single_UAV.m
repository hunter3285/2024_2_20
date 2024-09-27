% assume cell_matrix is done
s=Single_UAV_Solver;
if exist('cell_matrix', 'var')
    s.set_cells(cell_matrix);
end
s.initialize_DP_Solver();
%% test DP
% d=s.Solver_row(1);
% [sum_rate_optimal_dp_class, visited_dp_class, visited_dp_class_temp, visited_dp_class_temp_2,  all_step_dp_class, ~, ~, n_grid_class, ...
%     rate_vec_class]=d.get_dp_result;
% % %%
% power_vec_class=d.power_vec;
% mean_rate_class=s.mean_rate;
% error_class=d.get_correct_rate()+n_grid_class*mean_rate_class-sum_rate_optimal_dp_class
% %%
% d.power_parameters();
% d.power_optimization();
% %%
% gain_after_power_opt_class=d.rate_after_power_opt+n_grid_class*mean_rate_class-sum_rate_optimal_dp_class
% %%
% d.record_result();
% d.clear_dp();
% [sum_rate_optimal_dp_class, visited_dp_class, visited_dp_class_temp, visited_dp_class_temp_2,  all_step_dp_class, ~, ~, n_grid_class, ...
%     rate_vec_class]=d.get_dp_result();
% d.BCD_for_pow_path();

%%
% d.record_result();
% d.clear_dp();
% [sum_rate_optimal_dp_class, visited_dp_class, visited_dp_class_temp, visited_dp_class_temp_2,  all_step_dp_class, ~, ~, n_grid_heuristic, ...
%     rate_vec_class]=d.get_dp_result();
% d.BCD_for_pow_path();


%% test Heuristic
s.initialize_Heuristic_Solver;
h=s.heuristic_solver;
h.get_heuristic_result;
n_grid_heuristic=h.count_n_grid;
sum_rate_heuristic=h.sum_rate;

power_vec_class=h.power_vec;
mean_rate_class=s.mean_rate;
error_class=h.get_correct_rate()+n_grid_heuristic*mean_rate_class-sum_rate_heuristic
% 當最後一步是轉彎，無法偵測他是轉哪裡，因此有偵測到錯誤(error_class會是負的)，此時以sum_rate_heuristic為準

h.power_parameters();
h.power_optimization();
gain_after_power_opt_class=h.rate_after_power_opt+n_grid_heuristic*mean_rate_class-sum_rate_heuristic
error_power=h.get_correct_rate()-h.rate_after_power_opt
%% 
