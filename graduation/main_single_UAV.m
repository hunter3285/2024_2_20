clear;
s=Single_UAV_Solver;
d=s.Solver_row(1);
[sum_rate_optimal_dp_channel, visited_dp_channel, visited_dp_channel_temp, visited_dp_channel_temp_2,  all_step_dp_channel, ~, ~, n_grid_channel, ...
    rate_vec_channel]=d.get_dp_result;
%%
n_grid_count=d.count_n_grid();
if n_grid_channel~=n_grid_count
    disp('error in main n_grid');
    n_grid_count
    n_grid_channel
end
%%
power_vec=d.power_vec;
cell_matrix=s.cell_matrix;
mean_rate=s.mean_rate;
error=d.get_correct_rate()+n_grid_channel*mean_rate-sum_rate_optimal_dp_channel
%%
d.power_parameters();
d.power_optimization();
%%
gain_after_power_opt=d.rate_after_power_opt+n_grid_class*mean_rate-sum_rate_optimal_dp_channel
