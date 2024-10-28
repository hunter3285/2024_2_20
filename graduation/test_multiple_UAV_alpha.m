function [rate_dp, N_SAR_dp, comm_rate_dp, rate_sens, N_SAR_sens, ...
    comm_rate_sens, rate_comm, N_SAR_comm, comm_rate_comm]=test_multiple_UAV_alpha(alpha, Multiple_UAV_Solver_inst)


m=Multiple_UAV_Solver_inst;
m.mean_rate=m.mean_rate/alpha_multiplier*alpha;

disp(['Now alpha is ', num2str(alpha)])
m.initialize_DP_multi_Solver();




DP_Solver_multi_inst=m.Solver_row(1); % DP_Solver_multi
DP_Solver_multi_inst.BCD_for_UAV_paths_DP();
rate_dp=DP_Solver_multi_inst.total_sum_rate_row(end);
[total_visited, total_visited_2]=DP_Solver_multi_inst.get_total_visited(0); % 0 means all UAV will be calculated
N_SAR_dp=sum(total_visited, 'all')+sum(total_visited_2, 'all');
comm_rate_dp=DP_Solver_multi_inst.comm_rate_total;
if N_SAR_dp~=DP_Solver_multi_inst.n_grid_total
    disp("How to calculate ngrid in test_multiple_UAV_time")
    N_SAR_dp
    DP_Solver_multi_inst.n_grid_total
end
    


m.initialize_DP_comm_multi_Solver();
DP_comm_Solver_multi_inst=m.DP_comm_multi_Solver; % an DP_Solver_multi object
DP_comm_Solver_multi_inst.get_comm_paths();
rate_comm=DP_comm_Solver_multi_inst.total_sum_rate_row(end);
N_SAR_comm=DP_comm_Solver_multi_inst.n_grid_total;
comm_rate_comm=DP_comm_Solver_multi_inst.comm_rate_total;



m.initialize_DP_sens_multi_Solver();
DP_sens_Solver_multi_inst=m.DP_sens_multi_Solver;
DP_sens_Solver_multi_inst.get_sens_paths;
rate_sens=DP_sens_Solver_multi_inst.total_sum_rate_row(end);
N_SAR_sens=DP_sens_Solver_multi_inst.n_grid_total;
comm_rate_sens=DP_sens_Solver_multi_inst.comm_rate_total;





end