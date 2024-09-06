function [sum_rate_optimal_dp, visited_dp, all_step_dp, n_grid]=dp_sensing_area(sensing_matrix)

%% setup
% load('SARparams.mat');
load("cell_matrix.mat", "all_rate_matrix")
N_cell_x=size(all_rate_matrix,1);
N_cell_y=size(all_rate_matrix,2);
obstacle_matrix=zeros(N_cell_x, N_cell_y);
dp_inst=DP_class(sensing_matrix, obstacle_matrix);
%%
% tic;
[sum_rate_optimal_dp, max_index]=dp_inst.dp_main();
% toc;
%%
% dp_matrix=dp_inst.dp_matrix;
visited_reverse=zeros(dp_inst.N_cell_x, dp_inst.N_cell_y);
% visited_optimal=visited_reverse;
direction=ceil(max_index / 100)-1; % 0 to 3
real_index=(max_index-direction*100);
x=mod(real_index - 1, 10)+1;
y=ceil(real_index/10);
time=dp_inst.time_slot_max-1;
last_step_matrix=dp_inst.last_step_matrix;

n_grid=sum(dp_inst.visited_cells_matrix(x,y,direction+1, time+1, :), "all")+sum(dp_inst.visited_cells_matrix_2(x,y,direction+1, time+1, :), "all");
% dp_inst.visited_cells_matrix_2(x,y,direction+1, time+1, :)
% visited_matrix=dp_inst.visited_cells_matrix;
% all_rate_matrix=dp_inst.all_rate_matrix;
%% tracing the map
counter=1;
old_x=0;
old_y=0;
for i=1:dp_inst.time_slot_max
    % if visited_reverse(x,y)==0
   
    if old_x~=x || old_y~=y
        visited_reverse(x,y)=counter;
        all_step_dp(1,counter)=x;
        all_step_dp(2,counter)=y;
        counter=counter+1;
    end
    next_x=last_step_matrix(x,y,direction+1, time+1,1);
    next_y=last_step_matrix(x,y,direction+1, time+1,2);
    next_direction=last_step_matrix(x,y,direction+1, time+1,3);
    next_time=last_step_matrix(x,y,direction+1, time+1,4);
    old_x=x;
    old_y=y;
    x=next_x;
    y=next_y;
    direction=next_direction;
    time=next_time;
    if x==-1||y==-1||time==-1
        % counter;
        break;
    end
end
% last_x=mod(real_index - 1, 10)+1;
% last_y=ceil(real_index/10);
% last_direction=ceil(max_index / 100)-1; % 0 to 3
% last_time=dp_inst.time_slot_max;
% visited_cell_matrix=zeros(dp_inst.N_cell_x, dp_inst.N_cell_y);
% visited_cell_array=visited_matrix(last_x, last_y, last_direction+1, dp_inst.time_slot_max+1,:);
% visited_cell_array=visited_matrix(3, 1, 0+1, 100+1,:);
% for i=1:length(visited_cell_array)
%     temp_x=mod(i - 1, 10)+1;
%     temp_y=ceil(i/10);
%     visited_cell_matrix(temp_x, temp_y)=visited_cell_array(i);
% end
all_step_dp=flip(all_step_dp,2);
last_index=max(visited_reverse,[], 'all');
total=last_index+1;
visited_dp=(total-visited_reverse).*(visited_reverse~=0);






end