clear all;format shortG;
close all;
%% setting static parameters
load('SARparams.mat');

N_cell_x=10;
N_cell_y=10;


[cell_matrix, N_user_matrix, total_users, all_rate_matrix, coef_cell_matrix]=build_cells(N_cell_x, N_cell_y);
% [cell_matrix, N_users, total_users, all_rate_matrix]=build_cells_comm(N_cell_x, N_cell_y, cell_side, rho_r, N_range_cell, communication_matrix);
mean_rate=mean(all_rate_matrix,'all')*7;
% mean_rate=1e-9;


start=[5;5]; 
% current_point=start;
% current_middle=cell_matrix(current_point(1), current_point(2)).middle_point;
turn_cost_right=9;
turn_cost_left=13;
sensing_matrix=ones(N_cell_x, N_cell_y);

save('cell_matrix.mat',"N_cell_y", "N_cell_x","cell_side","turn_cost_left", "turn_cost_right",  "cell_matrix", "all_rate_matrix", "start", ...
    "sensing_matrix", "N_user_matrix", "mean_rate", "time_slot_max", "p_max_total", "coef_cell_matrix");
% [sum_rate_ser, visited_ser, all_step_ser, time_slot_max]=serpentine();

save('cell_matrix.mat',"time_slot_max", '-append');
N_max_user=get_max_user(cell_matrix);
% cell_matrix.mat sets variables for function use
%% setting varying parameters

N_UAV=3;
UAVs_step_with_time=zeros(N_UAV*2, time_slot_max);
UAVs_power_vec=zeros(N_UAV, time_slot_max);
last_step_turn_vec=zeros(1,N_UAV);
last_turn_right_or_left_vec=zeros(1,N_UAV);
UAV_total_rate_vec=zeros(1, N_UAV);
power_gain_vec=zeros(1, N_UAV);
total_visited=zeros(N_cell_x,N_cell_y);
total_visited_2=zeros(N_cell_x,N_cell_y);
rate_plot=[];
rate_plot_max=0;

%% main loop
for ii=1:N_UAV
    %% optimize path assuming power=1
    disp(['Now is UAV',num2str(ii)]);
    [total_visited, total_visited_2]=get_total_visited(ii, UAVs_step_with_time, last_step_turn_vec, last_turn_right_or_left_vec)
    sensing_matrix=mod(total_visited+1,2);
    sensing_matrix_2=mod(total_visited_2+1,2);
    power_vec=ones(1, time_slot_max)*p_mean;
    dp_inst_channel=DP_class_channel(sensing_matrix, sensing_matrix_2, zeros(N_cell_x, N_cell_y), power_vec);
    [sum_rate_optimal_dp_channel, visited_dp_channel, visited_dp_channel_temp, visited_dp_channel_temp_2, all_step_dp_channel, ~, ~, n_grid_channel, ...
        ~, dp_inst_channel]=dp_method_channel(dp_inst_channel);
    [all_step_with_time, last_step_turn, last_turn_right_or_left]=StepWithTimeSlot(all_step_dp_channel);
    n_grid_count=count_n_grid(all_step_dp_channel, N_cell_x, N_cell_y, start, sensing_matrix, sensing_matrix_2, last_step_turn);
    last_step_turn_vec(ii)=last_step_turn;
    last_turn_right_or_left_vec(ii)=last_turn_right_or_left;
    if n_grid_channel~=n_grid_count
        disp('error in main n_grid');
        n_grid_count
        n_grid_channel
    end
    % UAV_start_end=get_start_end(all_step_dp, cell_matrix, distance, cell_side);
    % image_heuristic=get_image(UAV_start_end,all_step_heuristic, N_range_cell, vr, T_PRI, cell_side, cell_matrix);
    % cell_matrix=get_image(UAV_start_end, all_step_dp, cell_matrix);
    [~, rate_vec_channel]=get_correct_rate(all_step_dp_channel, power_vec, cell_matrix);
    error=get_correct_rate(all_step_dp_channel, power_vec, cell_matrix)+n_grid_channel*mean_rate-sum_rate_optimal_dp_channel
    [coef_matrix, N_user_max, noise_variance_matrix, N_user_vec]=power_parameters(cell_matrix, all_step_dp_channel, N_user_matrix, time_slot_max, noise_variance);
    % optimize power the first time
    [popt, optval] = power_optimization(coef_matrix, N_user_max, p_max_total, noise_variance_matrix, N_user_vec);
    % N_azi=round(cell_side/vr/T_PRI);
    % plot_image(cell_matrix, N_azi);
    % flip(transpose(visited_dp)) 

    % BCD
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
    [sum_rate_optimal_dp_channel, visited_dp_channel, visited_dp_channel_temp, visited_dp_channel_temp_2, all_step_dp_channel, last_step_matrix_channel, dp_matrix_channel, n_grid_channel, ...
        rate_vec_channel, dp_inst_channel]=dp_method_channel(dp_inst_channel);

    error=(get_correct_rate(all_step_dp_channel, power_vec, cell_matrix)+n_grid_channel*mean_rate-sum_rate_optimal_dp_channel)...
        *isequal(all_step_dp_channel_old, all_step_dp_channel)

    % [~,rate_vec]=get_correct_rate(all_step_dp_channel, power_vec, cell_matrix);
    % after re-determine path based on power, if path changed then BCD starts
    n_iter=0;
    while ~isequal(all_step_dp_channel,all_step_dp_channel_old)
        n_iter=n_iter+1;
        [coef_matrix, N_user_max, noise_variance_matrix, N_user_vec]=power_parameters(cell_matrix, all_step_dp_channel, N_user_matrix, time_slot_max, noise_variance);
        [popt, optval] = power_optimization(coef_matrix, N_user_max, p_max_total, noise_variance_matrix, N_user_vec);
        power_vec=popt;
        gain_after_power_opt=get_correct_rate(all_step_dp_channel, power_vec, cell_matrix)+n_grid_channel*mean_rate-sum_rate_optimal_dp_channel
    
        dp_inst_channel.clear();
        dp_inst_channel.set_power_vec(power_vec)
        sum_rate_optimal_dp_channel_old=sum_rate_optimal_dp_channel;
        visited_dp_channel_old=visited_dp_channel;
        all_step_dp_channel_old=all_step_dp_channel;
        n_grid_channel_old=n_grid_channel;
        [sum_rate_optimal_dp_channel, visited_dp_channel, visited_dp_channel_temp, visited_dp_channel_temp_2, all_step_dp_channel, last_step_matrix_channel, dp_matrix_channel, n_grid_channel, ...
            rate_vec_channel, dp_inst_channel]=dp_method_channel(dp_inst_channel);

        error=(get_correct_rate(all_step_dp_channel, power_vec, cell_matrix)+n_grid_channel*mean_rate-sum_rate_optimal_dp_channel)...
            *isequal(all_step_dp_channel_old, all_step_dp_channel)
        % [~,rate_vec]=get_correct_rate(all_step_dp_channel, power_vec, cell_matrix);
        [all_step_with_time, ~, ~]=StepWithTimeSlot(all_step_dp_channel);
    end
    
    
    n_iter


    % [total_visited, total_visited_2]=update_total_visited(total_visited, total_visited_2, visited_dp_channel_temp, visited_dp_channel_temp_2);
    
    
    UAVs_power_vec(ii,:)=power_vec;
    UAVs_step_with_time(2*(ii-1)+1:2*ii,:)=all_step_with_time;
    UAV_total_rate_vec(ii)=sum_rate_optimal_dp_channel;
    power_gain_vec(ii)=gain_after_power_opt;
    error=get_all_UAV_rate(UAVs_step_with_time, UAVs_power_vec, cell_matrix)-sum(UAV_total_rate_vec)
    rate_plot=[rate_plot, sum(UAV_total_rate_vec)];
    rate_plot_max=rate_plot_max+1;
    disp('one UAV ended')
    
end




%% Now, every UAV has optimized once, optimize the second time for BCD

disp('Now it is second round')
for ii=1:N_UAV
    %%optimize path assuming power=1
    disp(['Now is UAV', num2str(ii)]);
    [total_visited, total_visited_2]=get_total_visited(ii, UAVs_step_with_time, last_step_turn_vec, last_turn_right_or_left_vec);
    sensing_matrix=mod(total_visited+1,2);
    sensing_matrix_2=mod(total_visited_2+1,2);
    power_vec=ones(1, time_slot_max)*p_mean;
    dp_inst_channel=DP_class_channel(sensing_matrix, sensing_matrix_2, zeros(N_cell_x, N_cell_y), power_vec);
    [sum_rate_optimal_dp_channel, visited_dp_channel, visited_dp_channel_temp, visited_dp_channel_temp_2, all_step_dp_channel, ~, ~, n_grid_channel, ...
        rate_vec_channel, dp_inst_channel]=dp_method_channel(dp_inst_channel);



    [~, last_step_turn, ~]=StepWithTimeSlot(all_step_dp_channel);

    n_grid_count=count_n_grid(all_step_dp_channel, N_cell_x, N_cell_y, start, sensing_matrix, sensing_matrix_2, last_step_turn);
    if n_grid_channel~=n_grid_count
        disp('error in main n_grid');
        n_grid_count
        n_grid_channel
    end
    
    % UAV_start_end=get_start_end(all_step_dp, cell_matrix, distance, cell_side);
    % 
    % image_heuristic=get_image(UAV_start_end,all_step_heuristic, N_range_cell, vr, T_PRI, cell_side, cell_matrix);
    % cell_matrix=get_image(UAV_start_end, all_step_dp, cell_matrix);
    
    error=get_correct_rate(all_step_dp_channel, power_vec, cell_matrix)+n_grid_channel*mean_rate-sum_rate_optimal_dp_channel
    last_step_turn_vec(ii)=last_step_turn;
    % should check reset of last_step_turn_vec
    
    [coef_matrix, N_user_max, noise_variance_matrix, N_user_vec]=power_parameters(cell_matrix, all_step_dp_channel, N_user_matrix, time_slot_max, noise_variance);
    [popt, optval] = power_optimization(coef_matrix, N_user_max, p_max_total, noise_variance_matrix, N_user_vec);
    
    % N_azi=round(cell_side/vr/T_PRI);
    % plot_image(cell_matrix, N_azi);
    % flip(transpose(visited_dp)) 

    %%BCD
    % in the above, the initial steps has been run:
    % 1. assuming unit power, optimize UAV path
    % 2. after 1., optimize transmission power at each time slot
    % the next thing wil be optimize path, then power, the repeat
    power_vec=popt;
    gain_after_power_opt=get_correct_rate(all_step_dp_channel, power_vec, cell_matrix)+n_grid_channel*mean_rate-sum_rate_optimal_dp_channel
    dp_inst_channel.clear();
    dp_inst_channel.set_power_vec(power_vec);

    sum_rate_optimal_dp_channel_old=sum_rate_optimal_dp_channel;
    visited_dp_channel_old=visited_dp_channel;
    all_step_dp_channel_old=all_step_dp_channel;
    n_grid_channel_old=n_grid_channel;
    
    [sum_rate_optimal_dp_channel, visited_dp_channel, visited_dp_channel_temp, visited_dp_channel_temp_2, all_step_dp_channel, last_step_matrix_channel, dp_matrix_channel, n_grid_channel, ...
        rate_vec_channel, dp_inst_channel]=dp_method_channel(dp_inst_channel);
    error=(get_correct_rate(all_step_dp_channel, power_vec, cell_matrix)+n_grid_channel*mean_rate-sum_rate_optimal_dp_channel)...
        *isequal(all_step_dp_channel_old, all_step_dp_channel)
    [~,rate_vec]=get_correct_rate(all_step_dp_channel, power_vec, cell_matrix);
    
    n_iter=0;
    while ~isequal(all_step_dp_channel,all_step_dp_channel_old)
        n_iter=n_iter+1;
        [coef_matrix, N_user_max, noise_variance_matrix, N_user_vec]=power_parameters(cell_matrix, all_step_dp_channel, N_user_matrix, time_slot_max, noise_variance);
        [popt, optval] = power_optimization(coef_matrix, N_user_max, p_max_total, noise_variance_matrix, N_user_vec);
        power_vec=popt;
        gain_after_power_opt=get_correct_rate(all_step_dp_channel, power_vec, cell_matrix)+n_grid_channel*mean_rate-sum_rate_optimal_dp_channel
    
        dp_inst_channel.clear();
        dp_inst_channel.set_power_vec(power_vec)
        sum_rate_optimal_dp_channel_old=sum_rate_optimal_dp_channel;
        visited_dp_channel_old=visited_dp_channel;
        all_step_dp_channel_old=all_step_dp_channel;
        n_grid_channel_old=n_grid_channel;
        [sum_rate_optimal_dp_channel, visited_dp_channel, visited_dp_channel_temp, visited_dp_channel_temp_2, all_step_dp_channel, last_step_matrix_channel, dp_matrix_channel, n_grid_channel, ...
            rate_vec_channel, dp_inst_channel]=dp_method_channel(dp_inst_channel);
        error=(get_correct_rate(all_step_dp_channel, power_vec, cell_matrix)+n_grid_channel*mean_rate-sum_rate_optimal_dp_channel)...
            *isequal(all_step_dp_channel_old, all_step_dp_channel)
        [~,rate_vec]=get_correct_rate(all_step_dp_channel, power_vec, cell_matrix);
    end
    [all_step_with_time, last_step_turn, last_turn_right_or_left]=StepWithTimeSlot(all_step_dp_channel);
    n_iter
    if ~isequal(all_step_with_time, UAVs_step_with_time(2*(ii-1)+1:2*ii,:))
        current_total_rate=get_all_UAV_rate(UAVs_step_with_time, UAVs_power_vec, cell_matrix);
        disp(['UAV ', num2str(ii), ' changed'])
        UAVs_power_vec(ii,:)=power_vec;
        UAVs_step_with_time_old=UAVs_step_with_time;
        UAVs_step_with_time(2*(ii-1)+1:2*ii,:)=all_step_with_time;
        UAV_total_rate_vec(ii)=sum_rate_optimal_dp_channel;
        power_gain_vec(ii)=gain_after_power_opt;
        new_total_rate=get_all_UAV_rate(UAVs_step_with_time, UAVs_power_vec, cell_matrix);
        disp(['rate from ', num2str(current_total_rate), ' to ', num2str(new_total_rate)])
    end
    error=get_all_UAV_rate(UAVs_step_with_time, UAVs_power_vec, cell_matrix)-sum(UAV_total_rate_vec)
    disp('one UAV ended')
    rate_plot=[rate_plot, get_all_UAV_rate(UAVs_step_with_time, UAVs_power_vec, cell_matrix)];
    rate_plot_max=rate_plot_max+1;

end
%%

plot(1:rate_plot_max, rate_plot, '-o')
%%
figure()

stem(1:N_UAV, power_gain_vec./UAV_total_rate_vec, 'o')
title('gain percentage on communication performance')
% plot(1:N_UAV, power_gain_vec, '*', 'r')


%%

disp('program ended')



