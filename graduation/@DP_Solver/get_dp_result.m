function [sum_rate_optimal_dp, visited_dp, visited_temp, visited_temp_2, all_step_dp, last_step_matrix, dp_matrix, n_grid, rate_vec]=...
    get_dp_result(obj)

%% setup
% load('SARparams.mat');


%%
% tic;
[sum_rate_optimal_dp, max_index]=obj.dp_main();
% toc;
%%
% dp_matrix=dp_inst.dp_matrix;
visited_reverse=zeros(obj.N_cell_x, obj.N_cell_y);
% visited_optimal=visited_reverse;
direction=ceil(max_index / 100)-1; % 0 to 3
real_index=(max_index-direction*100);
x=mod(real_index - 1, 10)+1;
y=ceil(real_index/10);
time=obj.time_slot_max-1;
last_step_matrix=obj.last_step_matrix;
dp_matrix=obj.dp_matrix;

visited_temp=zeros(obj.N_cell_x, obj.N_cell_y);
visited_temp_2=visited_temp;
for ii=1:obj.N_cell_x
    for jj=1:obj.N_cell_y
        visited_temp(ii,jj)=obj.visited_cells_matrix(x,y,direction+1, time+1, (jj-1)*10+ii);
        visited_temp_2(ii,jj)=obj.visited_cells_matrix_2(x,y,direction+1, time+1, (jj-1)*10+ii);
    end
end
n_grid=sum(visited_temp.*obj.sensing_matrix, "all")+ sum(visited_temp_2.*obj.sensing_matrix_2, "all");
% visited_matrix=dp_inst.visited_cells_matrix;
% all_rate_matrix=dp_inst.all_rate_matrix;
%% tracing the map
counter=1;
old_x=0;
old_y=0;
for i=1:obj.time_slot_max
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

%%
direction=ceil(max_index / 100)-1; % 0 to 3
real_index=(max_index-direction*100);
x=mod(real_index - 1, 10)+1;
y=ceil(real_index/10);
time=obj.time_slot_max-1;
rate_vec=zeros(1,size(all_step_dp,2));
for ii=1:size(all_step_dp,2)
    rate_vec(ii)=dp_matrix(x,y,direction+1, time+1);
    old_x=x;
    old_y=y;
    old_time=time;
    old_direction=direction;
    x=last_step_matrix(old_x,old_y,old_direction+1, old_time+1, 1);
    y=last_step_matrix(old_x,old_y,old_direction+1, old_time+1, 2);
    direction=last_step_matrix(old_x,old_y,old_direction+1, old_time+1, 3);
    time=last_step_matrix(old_x,old_y,old_direction+1, old_time+1, 4);
end


obj.sum_rate=sum_rate_optimal_dp;
obj.visited_matrix=visited_dp;
obj.rate_vec=rate_vec;
obj.all_step=all_step_dp;
obj.all_step_with_time=obj.StepWithTimeSlot(all_step_dp);
obj.visited_indicator_matrix=visited_temp;
obj.visited_indicator_matrix_2=visited_temp_2;



end