function [sum_rate_heuristic, visited_heuristic, all_step_heuristic]=heuristic()
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
    all_step_heuristic=[start(1);start(2)];
    current_point=start;
    sum_rate_heuristic=all_rate_matrix(current_point(1), current_point(2))+mean(all_rate_matrix,'all')*(sensing_matrix(start(1), start(2))==1);
    visited_heuristic=zeros(N_cell_x, N_cell_y);
    visited_heuristic(current_point(1), current_point(2))=1;
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
        
        [current_point, sum_rate_heuristic, visited_heuristic,all_step_heuristic, step_idx]=go_a_step(next_point, all_rate_matrix, sum_rate_heuristic, visited_heuristic,...
          all_step_heuristic, sensing_matrix, step_idx);
        old_direction=direction;
        % Now detemine the next direction (direction=next_direction),
        % with current_point has been changed to a new one
        % First, check the same direction
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



        if check_direction(point_to_check, N_cell_x, N_cell_y) && visited_heuristic(point_to_check(1), point_to_check(2))==0
            next_point=point_to_check;
            N_time_slot=N_time_slot+1;
        else % Then, check the one with largest rate
            four_directions=current_point+[1 0 -1  0;...
                                           0 1  0 -1];
            if old_direction==0
                three_directions=current_point+[1 0  0;...
                                               0 1 -1];
            elseif old_direction==1
                    three_directions=current_point+[1 0 -1;...
                                                   0 1  0];
            elseif old_direction==2
                    three_directions=current_point+[ 0 0 -1;...
                                                   -1 1  0];
            else
                three_directions=current_point+[1 -1  0;...
                                               0  0 -1];
            end
            max_rate_temp=0;
            max_step_temp=[0;0];
            direction_temp=-1;
            visited_direction_temp=-1;
            for jj=1:3
                point_to_check=three_directions(:,jj);
                if check_direction(point_to_check, N_cell_x, N_cell_y) && visited_heuristic(point_to_check(1), point_to_check(2))==0
                    if all_rate_matrix(point_to_check(1), point_to_check(2))>max_rate_temp
                        max_rate_temp=all_rate_matrix(point_to_check(1), point_to_check(2));
                        max_step_temp=point_to_check;
                        for kk=1:4
                            if point_to_check==four_directions(:,kk)
                                direction_temp=kk-1; %jj-1 is the real direction
                            end
                        end
                    end
                end
            end
            if direction_temp==-1
                for jj=1:3
                    point_to_check=three_directions(:,jj);
                    if check_direction(point_to_check, N_cell_x, N_cell_y)
                        if all_rate_matrix(point_to_check(1), point_to_check(2))>max_rate_temp
                            max_rate_temp=all_rate_matrix(point_to_check(1), point_to_check(2));
                            max_step_temp=point_to_check;
                            for kk=1:4
                                if point_to_check==four_directions(:,kk)
                                    direction_temp=kk-1; %kk-1 is the real direction
                                end
                            end
                        end
                    end
                end

            end
            if direction_temp==-1
                disp('dead end')
%                 current_point
%                 direction_temp
                break;
            else
                direction=direction_temp; % here, direction~=old_direction
                if direction~=old_direction
                    N_time_slot=N_time_slot+turn_cost;
                else
                    N_time_slot=N_time_slot+1;
                end
                next_point=max_step_temp;
            end
        end


    end
%     sum_rate_heuristic=sum_rate_heuristic-all_rate_matrix(current_point(1), current_point(2));
    if sum_rate_heuristic>max_rate
        max_rate=sum_rate_heuristic;
        max_visited=visited_heuristic;
        max_all_step=all_step_heuristic;
    end


end
sum_rate_heuristic=max_rate;
visited_heuristic=max_visited;
all_step_heuristic=max_all_step;
