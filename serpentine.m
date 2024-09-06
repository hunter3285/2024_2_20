function [sum_rate_optimal, visited, all_step, time_slot_max]=serpentine()
load('cell_matrix.mat', "N_cell_x", "N_cell_y", "all_rate_matrix", "turn_cost_right", "turn_cost_left", "start", "sensing_matrix");
% assume start=1,1  or 10,10
mean_rate=mean(all_rate_matrix, 'all');
current_point=start;
visited=zeros(N_cell_x, N_cell_y);
visited(start(1), start(2))=1;
step_idx=2;
all_step=[start(1);start(2)];
sum_rate=all_rate_matrix(start(1), start(2))+mean_rate;
time_slot_max=0;
if isequal(current_point,[1;1])
    if N_cell_x>N_cell_y
        direction=0;
    else
        direction=1;
    end
    state=0;% go straight
    % state=1: after one turn
    while(step_idx<=N_cell_x*N_cell_y)
        four_directions=current_point+[1 0 -1  0;...
                                       0 1  0 -1];
        point_to_check=four_directions(:,direction+1);
        if check_direction(point_to_check, N_cell_x, N_cell_y)&&state==0
            next_point=point_to_check;
            [current_point, sum_rate, visited, all_step,  step_idx]=go_a_step(next_point, all_rate_matrix, sum_rate, visited,...
            all_step, sensing_matrix , step_idx);
            time_slot_max=time_slot_max+1;
        elseif state==1
            
            state=0;
            left=mod(direction+1, 4);
            right=mod(direction-1, 4);
            if check_direction(four_directions(:, left+1), N_cell_x, N_cell_y)
                next_point=four_directions(:, left+1);
                direction=left;
            else
                next_point=four_directions(:, right+1);
                direction=right;
            end
            [current_point, sum_rate, visited, all_step,  step_idx]=go_a_step(next_point, all_rate_matrix, sum_rate, visited,...
             all_step, sensing_matrix , step_idx);
            if direction==left
                time_slot_max=time_slot_max+turn_cost_left;
            else
                time_slot_max=time_slot_max+turn_cost_right;
            end
        else
            state=1;
            left=mod(direction+1, 4);
            right=mod(direction-1, 4);
            if check_direction(four_directions(:, left+1), N_cell_x, N_cell_y)&&visited(four_directions(1, left+1), four_directions(2, left+1))==0
                next_point=four_directions(:, left+1);
                direction=left;
            else
                next_point=four_directions(:, right+1);
                direction=right;
            end
            [current_point, sum_rate, visited, all_step,  step_idx]=go_a_step(next_point, all_rate_matrix, sum_rate, visited,...
             all_step, sensing_matrix , step_idx);
            if direction==left
                time_slot_max=time_slot_max+turn_cost_left;
            else
                time_slot_max=time_slot_max+turn_cost_right;
            end
        end
    end


elseif isequal(current_point, [10;10])
    disp('for now')
else
    disp('start error')
end
sum_rate_optimal=sum_rate;
% time_slot_max=
end