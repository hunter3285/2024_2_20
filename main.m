clear all;format shortG;
close all;
%% setting static parameters
load('SARparams.mat');

N_cell_x=10;
N_cell_y=10;
% communication_matrix=zeros(N_cell_x, N_cell_y);
% communication_matrix(2, 6:10)=1;
% communication_matrix(10,1)=1;
[cell_matrix, N_user_matrix, total_users, all_rate_matrix, coef_cell_matrix]=build_cells(N_cell_x, N_cell_y);
% [cell_matrix, N_users, total_users, all_rate_matrix]=build_cells_comm(N_cell_x, N_cell_y, cell_side, rho_r, N_range_cell, communication_matrix);
mean_rate=mean(all_rate_matrix,'all');
% mean_rate=1e-9;


start=[5;5]; 
% current_point=start;
% current_middle=cell_matrix(current_point(1), current_point(2)).middle_point;
% turn_cost=9;
turn_cost_right=9;
turn_cost_left=13;
sensing_matrix=ones(N_cell_x, N_cell_y);
sensing_matrix_2=ones(N_cell_x, N_cell_y);

save('cell_matrix.mat',"N_cell_y", "N_cell_x","cell_side","turn_cost_left", "turn_cost_right",  "cell_matrix", "all_rate_matrix", "start", ...
    "sensing_matrix", "N_user_matrix", "mean_rate", "time_slot_max", "p_max_total", "coef_cell_matrix");
% [sum_rate_ser, visited_ser, all_step_ser, time_slot_max]=serpentine();

save('cell_matrix.mat',"time_slot_max", '-append');
N_max_user=get_max_user(cell_matrix);
% cell_matrix.mat sets variables for function use
%% setting varying parameters

% obstacle_matrix=zeros(N_cell_x, N_cell_y);
% obstacle_matrix(4,5)=1;
% obstacle_matrix(5,6)=1;
% obstacle_matrix(5,4)=1;
% obstacle_matrix(7,5)=1;
% obstacle_matrix(:, 6:10)=1;

%% exhaustive search (long time ago)

% tic;
% [sum_rate_exhaustive, visited_exhaustive, all_step_exhaustive]=exhaustive();
% toc;

%% original DP (without considering power allocation)
% tic;
% dp_inst_origianl=DP_class(ones(N_cell_x, N_cell_y), zeros(N_cell_x, N_cell_y));
% toc;
% tic;
% [sum_rate_optimal_dp, visited_dp, all_step_dp, last_step_matrix, dp_matrix, n_grid, dp_inst_origianl]=dp_method(dp_inst_origianl);
% toc;

%% DP considering power: optimize path assuming power=1
power_vec=ones(1, time_slot_max)*p_mean;
dp_inst_channel=DP_class_channel(ones(N_cell_x, N_cell_y), ones(N_cell_x, N_cell_y), zeros(N_cell_x, N_cell_y), power_vec);
[sum_rate_optimal_dp_channel, visited_dp_channel, visited_dp_channel_temp, visited_dp_channel_temp_2,  all_step_dp_channel, ~, ~, n_grid_channel, ...
    rate_vec_channel, dp_inst_channel]=dp_method_channel(dp_inst_channel);
% error=(sum_rate_optimal_dp-sum_rate_optimal_dp_channel)
% [sum_rate_optimal_dp, visited_dp, all_step_dp, n_grid]=dp_sensing_area(sensing_matrix);
% toc;
% tic;
% [sum_rate_optimal_dp, visited_dp, all_step_dp]=dp_obstacle(obstacle_matrix);
% toc;
% tic;
% [sum_rate_heuristic, visited_heuristic, all_step_heuristic]=heuristic();
% toc;
% tic;
% [sum_rate_optimal_comm, visited_comm, all_step_comm]=dp_sensing_area(zeros(N_cell_x, N_cell_y));
% toc;

% tic;
% [sum_rate_optimal_round, visited_round, all_step_round]=go_round();
% toc;
% % 查找唯一的列
% [unique_columns, ~, ~] = unique(all_step_comm', 'rows');
% 将结果转置回原始形状
% unique_columns = unique_columns';


% sum_rate_heuristic
% sum_rate_optimal_comm=sum_rate_optimal_comm+size(unique_columns,2)*mean_rate
% sum_rate_optimal_round
n_grid_count=count_n_grid(all_step_dp_channel, N_cell_x, N_cell_y, start, sensing_matrix, sensing_matrix_2);
if n_grid_channel~=n_grid_count
    disp('error in main n_grid');
    n_grid_count
    n_grid_channel
end
% visited_dp
%%
% all_step_with_time=StepWithTimeSlot(all_step_dp);

%%







% UAV_start_end=get_start_end(all_step_dp, cell_matrix, distance, cell_side);
%%
% image_heuristic=get_image(UAV_start_end,all_step_heuristic, N_range_cell, vr, T_PRI, cell_side, cell_matrix);
% cell_matrix=get_image(UAV_start_end, all_step_dp, cell_matrix);
%%
error=get_correct_rate(all_step_dp_channel, power_vec, cell_matrix)+n_grid_channel*mean_rate-sum_rate_optimal_dp_channel
all_step_with_time=StepWithTimeSlot(all_step_dp_channel);
%%
[coef_matrix, N_user_max, noise_variance_matrix, N_user_vec]=power_parameters(cell_matrix, all_step_dp_channel, N_user_matrix, time_slot_max, noise_variance);
%% optimize power the first time
[popt, optval] = power_optimization(coef_matrix, N_user_max, p_max_total, noise_variance_matrix, N_user_vec);
%%
% N_azi=round(cell_side/vr/T_PRI);
% plot_image(cell_matrix, N_azi);
% flip(transpose(visited_dp))



%% BCD
% in the above, the initial steps has been run:
% 1. assuming unit power, optimize UAV path
% 2. after 1., optimize transmission power at each time slot
% the next thing wil be optimize path, then power, the repeat
power_vec=popt;
gain_after_power_opt=get_correct_rate(all_step_dp_channel, power_vec, cell_matrix)+n_grid_channel*mean_rate-sum_rate_optimal_dp_channel
dp_inst_channel.clear();
dp_inst_channel.set_power_vec(power_vec)
sum_rate_optimal_dp_channel_old=sum_rate_optimal_dp_channel;
visited_dp_channel_old=visited_dp_channel;
all_step_dp_channel_old=all_step_dp_channel;
n_grid_channel_old=n_grid_channel;
%%
[sum_rate_optimal_dp_channel, visited_dp_channel, visited_dp_channel_temp, visited_dp_channel_temp_2, all_step_dp_channel, last_step_matrix_channel, dp_matrix_channel, n_grid_channel, ...
    rate_vec_channel, dp_inst_channel]=dp_method_channel(dp_inst_channel);
sum_rate_optimal_dp_channel_old
sum_rate_optimal_dp_channel
error=(get_correct_rate(all_step_dp_channel, power_vec, cell_matrix)+n_grid_channel*mean_rate-sum_rate_optimal_dp_channel)...
    *isequal(all_step_dp_channel_old, all_step_dp_channel)
[~,rate_vec]=get_correct_rate(all_step_dp_channel, power_vec, cell_matrix);
%%
n_iter=0;
while ~isequal(all_step_dp_channel,all_step_dp_channel_old)
    n_iter=n_iter+1;
    [coef_matrix, N_user_max, noise_variance_matrix, N_user_vec]=power_parameters(cell_matrix, all_step_dp_channel, N_user_matrix, time_slot_max, noise_variance);
    [popt, optval] = power_optimization(coef_matrix, N_user_max, p_max_total, noise_variance_matrix, N_user_vec);
    power_vec=popt;
    difference=get_correct_rate(all_step_dp_channel, power_vec, cell_matrix)+n_grid_channel*mean_rate-sum_rate_optimal_dp_channel

    dp_inst_channel.clear();
    dp_inst_channel.set_power_vec(power_vec)
    sum_rate_optimal_dp_channel_old=sum_rate_optimal_dp_channel;
    visited_dp_channel_old=visited_dp_channel;
    all_step_dp_channel_old=all_step_dp_channel;
    n_grid_channel_old=n_grid_channel;
    [sum_rate_optimal_dp_channel, visited_dp_channel, visited_dp_channel_temp, visited_dp_channel_temp_2, all_step_dp_channel, last_step_matrix_channel, dp_matrix_channel, n_grid_channel, ...
        rate_vec_channel, dp_inst_channel]=dp_method_channel(dp_inst_channel);
    sum_rate_optimal_dp_channel_old
    sum_rate_optimal_dp_channel
    difference=(get_correct_rate(all_step_dp_channel, power_vec, cell_matrix)+n_grid_channel*mean_rate-sum_rate_optimal_dp_channel)...
        *isequal(all_step_dp_channel_old, all_step_dp_channel)
    [~,rate_vec]=get_correct_rate(all_step_dp_channel, power_vec, cell_matrix);
end

%%
n_iter
disp('program ended')
UAVs_step_with_time=[all_step_with_time;zeros(2,time_slot_max)];%for test use



