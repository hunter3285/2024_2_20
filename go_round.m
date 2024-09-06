function [sum_rate_round, visited_round, all_step_round]=go_round()
% load('SARparams.mat');
load('cell_matrix.mat', "time_slot_max", "N_cell_x", "N_cell_y", "all_rate_matrix", "turn_cost", "start", "sensing_matrix");



current_point=start;
four_directions=current_point+[1 0 -1  0;...
                               0 1  0 -1];
valid_neighbor_point=[];
for ii=1:4
    if check_direction(four_directions(:,ii), N_cell_x, N_cell_y)
        valid_neighbor_point=[valid_neighbor_point, four_directions(:, ii)];
    end
end

max_rate=0;
for ii=1:size(valid_neighbor_point,2)
    all_step_round=[start(1);start(2)];
    current_point=start;
    sum_rate_round=all_rate_matrix(current_point(1), current_point(2))+mean(all_rate_matrix,'all')*(sensing_matrix(start(1), start(2))==1);
    visited_round=zeros(N_cell_x, N_cell_y);
    visited_round(current_point(1), current_point(2))=1;
    step_idx=2;
    N_time_slot=0;
    % First step, next_point is fixed by ii
    next_point=valid_neighbor_point(:,ii);
    if next_point==start+[1;0]
        direction=0;
    elseif next_point==start+[0;1]
        direction=1;
    elseif next_point==start+[-1;0]
        direction=2;
    elseif next_point==start+[0;-1]
        direction=3;
    else
        disp('eoeoe')
    end
    
    
    while N_time_slot<time_slot_max
        
        [current_point, sum_rate_round, visited_round,all_step_round, step_idx]=go_a_step(next_point, all_rate_matrix, sum_rate_round, visited_round,...
          all_step_round, sensing_matrix, step_idx);
        old_direction=direction;
        % Now detemine the next direction (direction=next_direction),
        % with current_point has been changed to a new one
        % First, check the same direction
        direction_added=[1 0 -1  0;...
                         0 1  0 -1];
        switch direction
            case 0
                point_to_check=current_point+[1;0];
            case 1
                point_to_check=current_point+[0;1];
            case 2
                point_to_check=current_point+[-1;0];
            case 3
                point_to_check=current_point+[0;-1];
            otherwise
                disp('error')
        end

        right=mod(direction+1,4)+1;
        left=mod(direction+3,4)+1;

        if check_direction(point_to_check, N_cell_x, N_cell_y) 
            next_point=point_to_check;
            N_time_slot=N_time_slot+1;
        elseif check_direction(current_point+direction_added(:, right), N_cell_x, N_cell_y) % +1 original and +1 right turn 
            next_point=current_point+direction_added(:, right);
            N_time_slot=N_time_slot+turn_cost;
            direction=right-1;
        elseif check_direction(current_point+direction_added(:, left), N_cell_x, N_cell_y)
            next_point=current_point+direction_added(:, left);
            N_time_slot=N_time_slot+turn_cost;
            direction=left-1;
        else
            disp('new dead end')
            break;
        end


    end
%     sum_rate_heuristic=sum_rate_heuristic-all_rate_matrix(current_point(1), current_point(2));
    if sum_rate_round>max_rate
        max_rate=sum_rate_round;
        max_visited=visited_round;
        max_all_step=all_step_round;
    end


end
sum_rate_round=max_rate;
visited_round=max_visited;
all_step_round=max_all_step;
