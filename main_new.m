clear;format shortG;
close all;
%% setting static parameters

load('SARparams.mat');

N_cell_x=10;
N_cell_y=10;
cell_side=100;


obstacle_matrix=zeros(N_cell_x, N_cell_y);
% obstacle_matrix(4,5)=1;
% obstacle_matrix(5,6)=1;
% obstacle_matrix(5,4)=1;
% obstacle_matrix(7,5)=1;
% obstacle_matrix(:, 6:10)=1;

start=[5;5]; 
current_point=start;


% time_slot_max=100;
turn_cost=10;
sensing_matrix=ones(N_cell_x, N_cell_y);

% cell_matrix.mat sets variables for function use
%% setting varying parameters
time_slot_max_array=[100 120 140 160 180 200];
%     time_slot_max_array=[60 140 180 220 260 300];
varying_param=time_slot_max_array;
N_paras=size(varying_param,2);
lines=zeros(15, N_paras);
for kk=1:N_paras
    N_iteration=5;
    
    rates_dp=           zeros(N_iteration,1);
    rates_heuristic=    zeros(N_iteration,1);
    rates_comm=         zeros(N_iteration,1);
    rates_obstacle=     zeros(N_iteration,1);
    rates_round=        zeros(N_iteration,1);
    
    N_grid_dp=           zeros(N_iteration,1);
    N_grid_heuristic=    zeros(N_iteration,1);
    N_grid_comm=         zeros(N_iteration,1);
    N_grid_obstacle=     zeros(N_iteration,1);
    N_grid_round=        zeros(N_iteration,1);
    
    comm_rates_dp=           zeros(N_iteration,1);
    comm_rates_heuristic=    zeros(N_iteration,1);
    comm_rates_comm=         zeros(N_iteration,1);
    comm_rates_obstacle=     zeros(N_iteration,1);
    comm_rates_round=        zeros(N_iteration,1);


    
    for ii=1:N_iteration
    
        [cell_matrix, N_users, total_users, all_rate_matrix]=build_cells(N_cell_x, N_cell_y, cell_side, rho_r, N_range_cell);
        time_slot_max=time_slot_max_array(kk);
        save('cell_matrix.mat',"N_cell_y", "N_cell_x","cell_side","turn_cost","time_slot_max",  "cell_matrix", "all_rate_matrix", "start", "sensing_matrix");
        mean_rate=mean(all_rate_matrix,'all');
        current_middle=cell_matrix(current_point(1), current_point(2)).middle_point;
        
        %%
        
        % [sum_rate_exhaustive, visited_exhaustive, all_step_exhaustive]=exhaustive();
        
        [sum_rate_optimal_dp, visited_dp, all_step_dp]=dp_method();
        [sum_rate_optimal_obstacle, visited_obstacle, all_step_obstacle,]=dp_obstacle(obstacle_matrix);
        [sum_rate_heuristic, visited_heuristic, all_step_heuristic]=heuristic();
        [sum_rate_optimal_comm, visited_com, all_step_comm]=dp_sensing_area(zeros(N_cell_x, N_cell_y));
        [sum_rate_optimal_round, visited_round, all_step_round]=go_round();
    
        [unique_columns, ~, ~] = unique(all_step_comm', 'rows');
        % 将结果转置回原始形状
        unique_columns = unique_columns';

        rates_dp(ii)=sum_rate_optimal_dp;
        rates_heuristic(ii)=sum_rate_heuristic;
        rates_comm(ii)=sum_rate_optimal_comm+size(unique_columns,2)*mean_rate;
        rates_obstacle(ii)=sum_rate_optimal_obstacle;
        rates_round(ii)=sum_rate_optimal_round;
    
    
        
    
        n_grid_dp=sum(visited_dp~=0, "all");
        n_grid_heuristic=sum(visited_heuristic~=0, "all");
        n_grid_comm=sum(visited_com~=0, 'all');
        n_grid_round=sum(visited_round~=0, 'all');
        n_grid_obstacle=sum(visited_obstacle~=0, "all");
    
    
        N_grid_dp(ii)=n_grid_dp;
        N_grid_heuristic(ii)=n_grid_heuristic;
        N_grid_comm(ii)=n_grid_comm;
        N_grid_obstacle(ii)=n_grid_obstacle;
        N_grid_round(ii)=n_grid_round;
    
        
        if n_grid_comm~=size(unique_columns,2)
            disp('comm error')
        end
        comm_rates_dp(ii)=sum_rate_optimal_dp-n_grid_dp*mean_rate;
        comm_rates_heuristic(ii)=sum_rate_heuristic-n_grid_heuristic*mean_rate;
        comm_rates_comm(ii)=sum_rate_optimal_comm;
        comm_rates_round(ii)=sum_rate_optimal_round-n_grid_round*mean_rate;
        comm_rates_obstacle(ii)=sum_rate_optimal_obstacle-n_grid_obstacle*mean_rate;
        
        if sum_rate_optimal_comm>sum_rate_optimal_dp || sum_rate_heuristic>sum_rate_optimal_dp
            disp('eoororo')
        end
        %% 
        
        
        % UAV_start_end=get_start_end(all_step_com, cell_matrix, distance, cell_side);
        %%
        % image_heuristic=get_image(UAV_start_end,all_step_heuristic, N_range_cell, vr, T_PRI, cell_side, cell_matrix);
        % [image_dp, cell_matrix]=get_image(UAV_start_end,all_step_dp, N_range_cell, vr, T_PRI, cell_side, cell_matrix);
        %%
        % plot_image(cell_matrix, N_range_cell);
        % flip(transpose(visited_dp))
    end
    
    mean_rates_dp=mean(rates_dp);
    mean_rates_heuristic=mean(rates_heuristic);
    mean_rates_round=mean(rates_round);
    mean_rates_obstacle=mean(rates_obstacle);
    mean_rates_comm=mean(rates_comm);
    mean_N_grid_dp=mean(N_grid_dp);
    mean_N_grid_heuristic=mean(N_grid_heuristic);
    mean_N_grid_round=mean(N_grid_round);
    mean_N_grid_obstacle=mean(N_grid_obstacle);
    mean_N_grid_comm=mean(N_grid_comm);
    mean_comm_rates_dp=mean(comm_rates_dp);
    mean_comm_rates_heuristic=mean(comm_rates_heuristic);
    mean_comm_rates_round=mean(comm_rates_round);
    mean_comm_rates_obstacle=mean(comm_rates_obstacle);
    mean_comm_rates_comm=mean(comm_rates_comm);

    
    lines(1, kk)=mean_rates_dp;
    lines(2, kk)=mean_rates_heuristic;
    lines(3, kk)=mean_rates_round;
    lines(4, kk)=mean_rates_obstacle;
    lines(5, kk)=mean_rates_comm;
    lines(6, kk)=mean_N_grid_dp;
    lines(7, kk)=mean_N_grid_heuristic;
    lines(8, kk)=mean_N_grid_round;
    lines(9, kk)=mean_N_grid_obstacle;
    lines(10, kk)=mean_N_grid_comm;
    lines(11, kk)=mean_comm_rates_dp;
    lines(12, kk)=mean_comm_rates_heuristic;
    lines(13, kk)=mean_comm_rates_round;
    lines(14, kk)=mean_comm_rates_obstacle;
    lines(15, kk)=mean_comm_rates_comm;
    
end 
%%
figure()
plot(varying_param, lines(1, :), '-o')
hold on
plot(varying_param, lines(2, :), '-o')
plot(varying_param, lines(3, :), '-o')
plot(varying_param, lines(4, :), '-o')
plot(varying_param, lines(5, :), '-o')
legend('Dynamic programming', 'Heuristic', 'Go round', 'With obstacle', 'Communication only')
title('Average Reward vs. Time Limit')
ylabel 'Reward (bit/Hz)'
xlabel("time limit (time slot)")
% legend('Dynamic programming', 'Heuristic', 'Go round', 'Communication only')
%%
figure()
plot(varying_param, lines(6, :), '-o')
hold on
plot(varying_param, lines(7, :), '-o')
plot(varying_param, lines(8, :), '-o')
plot(varying_param, lines(9, :), '-o')
plot(varying_param, lines(10, :), '-o')
legend('Dynamic programming', 'Heuristic', 'Go round', 'With obstacle', 'Communication only')
title('Number of Visited Cells vs. Time Limit')
ylabel 'Number of Visited Cells'
xlabel("time limit (time slot)")
% legend('Dynamic programming', 'Heuristic', 'Go round', 'Communication only')
%%
figure()
plot(varying_param, lines(11, :), '-o')
hold on
plot(varying_param, lines(12, :), '-o')
plot(varying_param, lines(13, :), '-o')
plot(varying_param, lines(14, :), '-o')
plot(varying_param, lines(15, :), '-o')
legend('Dynamic programming', 'Heuristic', 'Go round', 'With obstacle', 'Communication only')
title('Communication Rate vs. Time Limit')
ylabel 'Rate (bit/Hz)'
xlabel("time limit (time slot)")
% legend('Dynamic programming', 'Heuristic', 'Go round', 'Communication only')


