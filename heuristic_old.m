function [sum_rate_heuristic, visited_heuristic, all_step_heuristic]=heuristic_old()
clear;
load('SARparams.mat');
load('cell_matrix.mat', "time_slot_max", "N_cell_x", "N_cell_y", "all_rate_matrix", "turn_cost", "start", "cell_matrix");





visited_heuristic=zeros(N_cell_x, N_cell_y);
current_point=start;

two_direction=north_south;%initial assumption
% UAV_path=[];
sum_rate_heuristic=0;
turns=0;
straight=0;
N_time_slot=0;

% time_slot_max=100; % in cell_matrix.mat
ii=1;
% current_middle=cell_matrix(current_point(1), current_point(2)).middle_point;
max_sum_rate=0;
for step=0:1:3
    % max_step=0;
    sum_rate_heuristic=0;
    current_point=start;
    visited_heuristic=zeros(N_cell_x, N_cell_y);
    % max_sum_rate=0;
    while N_time_slot<time_slot_max

%         end
        if visited_heuristic(current_point(1), current_point(2))==0
            sum_rate_heuristic=sum_rate_heuristic+mean(all_rate_matrix,"all");
        end
        visited_heuristic(current_point(1), current_point(2))=ii;
        sum_rate_heuristic=sum_rate_heuristic+cell_matrix(current_point(1), current_point(2)).sum_rate;
        all_step_heuristic(1, ii)=current_point(1);
        all_step_heuristic(2, ii)=current_point(2);
        left=[current_point(1)-1;current_point(2)];
        right=[current_point(1)+1;current_point(2)];
        upper=[current_point(1);current_point(2)+1];
        lower=[current_point(1);current_point(2)-1];
        four_directions=[right,upper, left, lower];
        %真正的位置：左下開始，但矩陣印出來是左上開始
        %而且第一個axis代表的是x軸(在我的設定中)，但矩陣印出來會在y軸
        %所以印出來是上下顛倒，兩軸相反
        availabe_directions=[];
        for jj=1:size(four_directions,2)%4
            point_to_check=four_directions(:,jj);
            if (point_to_check(2)>0 && point_to_check(1)>0 && ...
                    point_to_check(2)<=N_cell_y && point_to_check(1)<=N_cell_x)
                % if visited_heuristic(point_to_check(1),point_to_check(2))==0%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    availabe_directions=[availabe_directions,point_to_check];
                % end
            end
        end
        error_dead_end=isempty(availabe_directions);
        max_profit=0;
        straight_profit=0;
        turn_profit=0;
        if ~error_dead_end
            next_point=availabe_directions(:,1);
        else
            break;
        end
        %method 1: find max profit
    %     for jj=1:size(availabe_directions,2)
    %         cell_to_check=cell_matrix(availabe_directions(1,jj), availabe_directions(2,jj));
    %         if cell_to_check.sum_rate>max_profit
    %             next_point=availabe_directions(:,jj);
    %             max_profit=cell_to_check.sum_rate;
    %         end
    %     end
        %method 2: go straight first
        % N_left_point=0;
        % if isequal(current_point, upper_last)&&ismember(upper.', availabe_directions.', 'rows')
        %     next_point=upper;
        % elseif isequal(current_point, lower_last)&&ismember(lower.', availabe_directions.', 'rows')
        %     next_point=lower;
        % elseif isequal(current_point, left_last)&&ismember(left.', availabe_directions.', 'rows')
        %     next_point=left;
        % elseif isequal(current_point, right_last)&&ismember(right.', availabe_directions.', 'rows')
        %     next_point=right;
        % else
        %     N_left_point=size(availabe_directions,2);
        %     for jj=1:size(availabe_directions,2)
        %         cell_to_check=cell_matrix(availabe_directions(1,jj), availabe_directions(2,jj));
        %         if cell_to_check.sum_rate>max_profit
        %             next_point=availabe_directions(:,jj);
        %             max_profit=cell_to_check.sum_rate;
        %         end
        %     end
        % end
        point_to_check=four_directions(:,step+1); % +1 maps 0:3(step) to 1:4 (col idx)
        if check_direction(point_to_check, N_cell_x, N_cell_y)
            next_point=point_to_check;
        else
            left_step=mod(step+1,4); %turn left
            point_to_check_left=four_directions(:,left_step+1);
            right_step=mod(step-1,4); %turn right
            point_to_check_right=four_directions(:,right_step+1);
            if ~check_direction(point_to_check_left, N_cell_x, N_cell_y) && ~check_direction(point_to_check_right, N_cell_x, N_cell_y)
                break;
            elseif ~check_direction(point_to_check_left, N_cell_x, N_cell_y)
                next_point=point_to_check_right;
                step=mod(step-1,4);
            elseif ~check_direction(point_to_check_right, N_cell_x, N_cell_y)
                next_point=point_to_check_left;
                step=mod(step+1,4);
            else
                if all_rate_matrix(point_to_check_left(1), point_to_check_left(2))>all_rate_matrix(point_to_check_right(1), point_to_check_right(2))
                    next_point=point_to_check_left;
                    step=mod(step+1,4);
                else
                    next_point=point_to_check_right;
                    step=mod(step-1,4);
                end
            end
    
        end
        %method 3: evaluate the cost/price(time slot) value
    %     for jj=1:size(availabe_directions,2)
    %         cell_to_check=cell_matrix(availabe_directions(1,jj), availabe_directions(2,jj));
    %         point_to_check=[availabe_directions(1,jj); availabe_directions(2,jj)];
    %         if (isequal(point_to_check,upper) && isequal(current_point, upper_last))||...
    %                 (isequal(point_to_check,lower) && isequal(current_point, lower_last))||...
    %                 (isequal(point_to_check,right) && isequal(current_point, right_last))||...
    %                 (isequal(point_to_check,left) && isequal(current_point, left_last))
    %             rate_to_check=cell_to_check.sum_rate*14+40;
    %         else
    %             rate_to_check=cell_to_check.sum_rate;
    %         end
    %         if rate_to_check>max_profit
    %             next_point=availabe_directions(:,jj);
    %             max_profit=rate_to_check;
    %         end
    %     end
        %method 4: TBD
    
        last_two_direction=two_direction;
        if isequal(next_point,lower) || isequal(next_point,upper)
            two_direction=north_south;
        else
            two_direction=east_west;
        end
        if ii~=1&&two_direction~=last_two_direction
            turns=turns+1;
            N_time_slot=N_time_slot+turn_cost;
        else
            straight=straight+1;
            N_time_slot=N_time_slot+1;
        end
    
    
        last_point=current_point;
        current_point=next_point;
       
            
    ii=ii+1;
    end
    if sum_rate_heuristic>max_sum_rate
        max_step=step;
        max_sum_rate=sum_rate_heuristic;
        max_all_path_heuristic=all_step_heuristic;
        max_visited=visited_heuristic;
    end
end
all_step_heuristic=max_all_path_heuristic;
sum_rate_heuristic=max_sum_rate;
visited_heuristic=max_visited;
end