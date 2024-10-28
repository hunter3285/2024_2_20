function [rate_dp, N_SAR_dp, comm_rate_dp, rate_heu, N_SAR_heu, comm_rate_heu, ...
    rate_sens, N_SAR_sens, comm_rate_sens, rate_comm, N_SAR_comm, comm_rate_comm]=test_single_UAV_time(time_slot_max, Single_UAV_Solver_inst)

% 輸入Single_UAV_Solver_inst可以確保每次的地圖都一樣，只有改變Single_UAV_Solver_inst才會改地圖
s=Single_UAV_Solver_inst;


s.time_slot_max=time_slot_max;
s.power_initial_vec=s.p_mean*ones(1, time_slot_max);
s.p_max_total= s.time_slot_max* s.p_mean;
s.initialize_DP_Solver();
%% test DP
d=s.Solver_row(1);
[rate_dp, N_SAR_dp, comm_rate_dp]=d.get_BCD_result();



%% test Heuristic
s.initialize_Heuristic_Solver;
h=s.heuristic_solver;
h.get_heuristic_result;
n_grid_heuristic=h.count_n_grid;
sum_rate_heuristic=h.sum_rate;

mean_rate_class=s.mean_rate;
error_h=h.get_correct_rate()+n_grid_heuristic*mean_rate_class-sum_rate_heuristic
% 當最後一步是轉彎，無法偵測他是轉哪裡，因此有偵測到錯誤(error_class會是負的)，此時以sum_rate_heuristic為準

h.power_parameters();
h.power_optimization();
gain_after_power_opt_class=h.rate_after_power_opt+n_grid_heuristic*mean_rate_class-sum_rate_heuristic
error_power=h.get_correct_rate()-h.rate_after_power_opt

rate_heu=h.get_correct_rate+h.n_grid*h.mean_rate;
N_SAR_heu=h.n_grid;
comm_rate_heu=h.get_correct_rate;
%% communication only

s.initialize_DP_comm_Solver;
c=s.dp_solver_communication;
[sum_rate_comm, ~, ~, ~,  ~, ~, ~, n_grid_comm, ~]=c.get_dp_result;
% %%

error_c=c.get_correct_rate()+n_grid_comm*mean_rate_class-sum_rate_comm

c.power_parameters();
c.power_optimization();
gain_after_power_opt_class=c.rate_after_power_opt+n_grid_comm*mean_rate_class-sum_rate_comm
error_power=c.get_correct_rate()-c.rate_after_power_opt

comm_rate_comm=c.get_correct_rate();
c.sensing_matrix=ones(c.N_cell_x, c.N_cell_y);
c.sensing_matrix_2=ones(c.N_cell_x, c.N_cell_y);
N_SAR_comm=c.count_n_grid;
rate_comm=comm_rate_comm+N_SAR_comm*mean_rate_class;


%% sensing centric

s.initalize_DP_sens_Solver;
sens=s.dp_solver_sensing;
[sum_rate_sens, ~, ~, ~,  ~, ~, ~, n_grid_sens, ~]=sens.get_dp_result;
sens.coef_vec_cell_matrix=c.coef_vec_cell_matrix;
error_sens=sens.get_correct_rate()+n_grid_sens*(sens.mean_rate)-sum_rate_sens

sens.power_parameters();
sens.power_optimization();
gain_after_power_opt_class=sens.rate_after_power_opt+n_grid_sens*(sens.mean_rate)-sum_rate_sens
error_power=sens.get_correct_rate()-sens.rate_after_power_opt

comm_rate_sens=sens.get_correct_rate();
N_SAR_sens=sens.n_grid;
rate_sens=comm_rate_sens+N_SAR_sens*mean_rate_class;





end