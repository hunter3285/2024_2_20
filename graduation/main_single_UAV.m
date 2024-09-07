clear all;
s=Single_UAV_Solver;
d=s.Solver_row(1);
[sum_rate_optimal_dp_channel, visited_dp_channel, visited_dp_channel_temp, visited_dp_channel_temp_2,  all_step_dp_channel, ~, ~, n_grid_channel, ...
    rate_vec_channel]=d.get_dp_result;

n_grid_count=d.count_n_grid();
if n_grid_channel~=n_grid_count
    disp('error in main n_grid');
    n_grid_count
    n_grid_channel
end