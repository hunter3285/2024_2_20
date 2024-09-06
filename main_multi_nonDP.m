clear;format shortG;
close all;
%% setting static parameters

load('SARparams.mat');

N_cell_x=10;
N_cell_y=10;
cell_side=100;
% communication_matrix=zeros(N_cell_x, N_cell_y);
% communication_matrix(2, 6:10)=1;
% communication_matrix(10,1)=1;
% [cell_matrix, N_users, total_users, all_rate_matrix]=build_cells(N_cell_x, N_cell_y, cell_side, rho_r, N_range_cell);
% [cell_matrix, N_users, total_users, all_rate_matrix]=build_cells_comm(N_cell_x, N_cell_y, cell_side, rho_r, N_range_cell, communication_matrix);
% mean_rate=mean(all_rate_matrix,'all');



start=[5;5]; 
% current_point=start;
% current_middle=cell_matrix(current_point(1), current_point(2)).middle_point;
turn_cost_right=9;
turn_cost_left=13;
% sensing_matrix=ones(N_cell_x, N_cell_y);
% save('cell_matrix.mat',"N_cell_y", "N_cell_x","cell_side","turn_cost",  "cell_matrix", "all_rate_matrix", "start", "sensing_matrix");

time_slot_max=100;
save('cell_matrix.mat',"N_cell_y", "N_cell_x","cell_side","time_slot_max", "turn_cost_right", "turn_cost_left","start");
% cell_matrix.mat sets variables for function use

N_UAV=3;

N_iter=1;
rate_1=zeros(5,1);
rate_2=zeros(5,1);
rate_3=zeros(5,1);
N_grid_1_array=zeros(5,1);
N_grid_2_array=zeros(5,1);
N_grid_3_array=zeros(5,1);
%%
% [sum_rate_ser, visited_ser, all_step_ser, time_slot_max]=serpentine();
% sum_rate_ser
% sum_rate_ser_comm=sum_rate_ser-100*mean_rate
%% setting varying parameters

for jj=1:N_iter
    [cell_matrix, N_users, total_users, all_rate_matrix]=build_cells(N_cell_x, N_cell_y, cell_side, rho_r, N_range_cell);
    save('cell_matrix.mat',  "cell_matrix", "all_rate_matrix", '-append');
    %% Method 1
%     step_with_time=zeros(2*N_UAV, time_slot_max);
%     sum_rate_method_1=0;
%     visited_all=zeros(N_cell_x, N_cell_y);
%     sensing_matrix=ones(N_cell_x, N_cell_y);
%     save('cell_matrix.mat', "sensing_matrix", '-append')
%     for ii=1:N_UAV
%         [sum_rate_optimal_dp, visited_dp, all_step_dp]=dp_sensing_area(sensing_matrix);
%         visited_dp;
%         visited_all=visited_all+visited_dp;
%         sensing_matrix=sensing_matrix-(visited_dp>0);
%         sensing_matrix=sensing_matrix>0;
%         save('cell_matrix.mat', "sensing_matrix", '-append');
%         step_with_time(2*ii-1:2*ii, :)=StepWithTimeSlot(all_step_dp);
%         sum_rate_method_1=sum_rate_method_1+GainedCapacity(all_step_dp);
%     
%     
%     
%     end
%     visited_all=visited_all>0;
%     sum_rate_method_1=sum_rate_method_1+GainedSensing(visited_all, ones(N_cell_x, N_cell_y));
%     N_grid_1=sum(visited_all,"all");
%     rate_1(jj)=sum_rate_method_1;
%     N_grid_1_array(jj)=N_grid_1;
    %% Method 2 {original (with sensing matrix) start}
    sensing_matrix_all=zeros(N_cell_x*3, N_cell_y);
    sensing_matrix_all(1:2,:)=1;
    sensing_matrix_all(3:5, 4:10)=1;
    sensing_matrix_all(10+3:10+10,1:3)=1;
    sensing_matrix_all(10+5:10+10, 4:5)=1;
    sensing_matrix_all(20+6:20+10, 6:10)=1;

    %% deciding map
    map=DistantPoints(N_cell_x, N_cell_y, N_UAV+1, start);
    map=(map-1).*((map-1)>0);

    map_last=zeros(size(map, 1), size(map, 2));
    while ~isequal(map,map_last)
        map_last=map;
        map=WaveFront(map, N_UAV);
    end
    map_new=SmoothEdge(map);
    while ~isequal(map,map_new)
        map=map_new;
        map_new=SmoothEdge(map);
    end
    %%





    map2=DistantPoints(N_cell_x, N_cell_y, N_UAV+1, start);
    map2=(map2-1).*((map2-1)>0);

    map_last2=zeros(size(map2, 1), size(map2, 2));
    while ~isequal(map2,map_last2)
        map_last2=map2;
        map2=WaveFront(map2, N_UAV);
    end
    map2
    % map2: no smooth edge
%     map_new2=SmoothEdge(map2);
%     while ~isequal(map2,map_new2)
%         map2=map_new2;
%         map_new2=SmoothEdge(map2);
%     end

    %% method 2


    step_with_time=zeros(2*N_UAV, time_slot_max);
    visited_all=zeros(N_cell_x, N_cell_y);
    sum_rate_method_2=0;
    
    for ii=1:N_UAV
        % Assume rectangle map
        sensing_matrix=(map==ii);
%         sensing_matrix=sensing_matrix_all((ii-1)*N_cell_x+1:ii*N_cell_x,:)
        save('cell_matrix.mat', "sensing_matrix", '-append');
        [sum_rate_optimal_dp, visited_dp, all_step_dp]=dp_sensing_area(sensing_matrix);
        visited_dp;
        visited_all=visited_all+visited_dp;
        step_with_time(2*ii-1:2*ii, :)=StepWithTimeSlot(all_step_dp);
        sum_rate_method_2=sum_rate_method_2+GainedCapacity(all_step_dp);
    end
    visited_all=visited_all>0;
    sum_rate_method_2=sum_rate_method_2+GainedSensing(visited_all, ones(N_cell_x, N_cell_y));
    N_grid_2=sum(visited_all,'all');
    rate_2(jj)=sum_rate_method_2;
    N_grid_2_array(jj)=N_grid_2;



%% method 3
    step_with_time=zeros(2*N_UAV, time_slot_max);
    visited_all=zeros(N_cell_x, N_cell_y);
    sum_rate_method_3=0;
    
    for ii=1:N_UAV
        % Assume rectangle map
        sensing_matrix=(map2==ii);
        save('cell_matrix.mat', "sensing_matrix", '-append');
        [sum_rate_optimal_dp, visited_dp, all_step_dp]=dp_sensing_area(sensing_matrix);
        visited_all=visited_all+visited_dp;
        step_with_time(2*ii-1:2*ii, :)=StepWithTimeSlot(all_step_dp);
        sum_rate_method_3=sum_rate_method_3+GainedCapacity(all_step_dp);
    end
    visited_all=visited_all>0;
    sum_rate_method_3=sum_rate_method_3+GainedSensing(visited_all, ones(N_cell_x, N_cell_y));
    N_grid_3=sum(visited_all,'all');
    rate_3(jj)=sum_rate_method_3;
    N_grid_3_array(jj)=N_grid_3;
end
%%
[valid, time]=CheckStepCollision(step_with_time);
% avg_sum_rate_1=mean(rate_1);
avg_sum_rate_2=mean(rate_2)
avg_sum_rate_3=mean(rate_3)
% avg_N_grid_1=mean(N_grid_1_array);
avg_N_grid_2=mean(N_grid_2_array)
avg_N_grid_3=mean(N_grid_3_array)
rate_2>rate_3




