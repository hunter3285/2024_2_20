function [ profit]=dp_rec(obj, x, y, direction, time) % time=0:obj.time_slot_max-1
    if ~obj.check_direction([x;y])
        profit=0;
        return;
    end
    if time<0
        profit=0;
        return;
    end
    % when using direction as index of matrix, +1 to become 1:4
    visited_index=(y-1)*obj.N_cell_x+x;
    if obj.dp_matrix(x,y,direction+1, time+1)==-1 % not yet calculated
        if time==0
            if x==obj.start(1) && y==obj.start(2) %  time=0 at start point
                profit=obj.get_rate(x,y,time);
                if obj.sensing_matrix(x, y)==1 && (direction==0||direction==2)
                %    if (direction==0||direction==2) && obj.visited_cells_matrix(x,y,direction+1, time+1, visited_index)==0
                    profit=profit+obj.mean_rate;
                %    elseif (direction==1||direction==3) && obj.visited_cells_matrix_2(x,y,direction+1, time+1, visited_index)==0
                %       profit=profit+obj.mean_rate;
                %    end
                end
                if obj.sensing_matrix_2(x, y)==1 && (direction==1||direction==3)
                %    if (direction==0||direction==2) && obj.visited_cells_matrix(x,y,direction+1, time+1, visited_index)==0
                    profit=profit+obj.mean_rate;
                %    elseif (direction==1||direction==3) && obj.visited_cells_matrix_2(x,y,direction+1, time+1, visited_index)==0
                %       profit=profit+obj.mean_rate;
                %    end
                end
                if obj.sensing_matrix(x, y)==0 && obj.sensing_matrix_2(x,y)==0;
                    profit=profit+1e-6; % in case the rate is zero
                end
                % if sum(obj.sensing_matrix+obj.sensing_matrix_2,'all')==0 && obj.get_rate(obj.start(1), obj.start(2), 0)==0
                %     profit=profit+1e-6; % in case the rate is zero
                % end
                obj.dp_matrix(x,y,direction+1, time+1)=profit;
                if direction==0||direction==2
                    obj.visited_cells_matrix(x,y, direction+1, time+1, visited_index)=1;
                else
                    obj.visited_cells_matrix_2(x,y, direction+1, time+1, visited_index)=1;
                end
                return;%%% see if there are some still other things to do
            else %  time=0 but not at start point
                profit=0;
                obj.dp_matrix(x,y,direction+1, time+1)=profit;
                return;
            end
    %     elseif time>time_slot_max
    %         disp('error time slot')
    %         return;
        end
    
    
    
        % the rest: time>0 and hasn't solved yet
        direction_left_turn=mod(direction-1,4);
        direction_right_turn=mod(direction+1, 4);
        if direction==0 % right
            profit_straight=obj.dp_rec(x-1, y, direction, time-1);
            if profit_straight>0
                profit_straight=profit_straight+(obj.visited_cells_matrix(x-1,y,direction+1, time-1+1, visited_index)==0)...
                    *(obj.sensing_matrix(x,y)==1)*obj.mean_rate;
            end
            profit_left_turn=obj.dp_rec(x, y+1, direction_left_turn, time-obj.turn_cost_left);
            if profit_left_turn>0
                profit_left_turn=profit_left_turn+(obj.visited_cells_matrix(x,y+1,direction_left_turn+1, time-obj.turn_cost_left+1, visited_index)==0)...
                    *(obj.sensing_matrix(x,y)==1)*obj.mean_rate;
                for ii =1:obj.turn_cost_left-1
                    profit_left_turn=profit_left_turn+obj.get_rate(x,y,time-ii);
                end
                % profit_left_turn=profit_left_turn+obj.get_rate(x,y,time-obj.turn_cost_left)*(obj.turn_cost_left-1);
            end
            profit_right_turn=obj.dp_rec(x, y-1, direction_right_turn, time-obj.turn_cost_right);
            if profit_right_turn>0
                profit_right_turn=profit_right_turn+(obj.visited_cells_matrix(x,y-1,direction_right_turn+1, time-obj.turn_cost_right+1, visited_index)==0)...
                    *(obj.sensing_matrix(x,y)==1)*obj.mean_rate;
                for ii =1:obj.turn_cost_right-1
                    profit_right_turn=profit_right_turn+obj.get_rate(x,y,time-ii);
                end
                % profit_right_turn=profit_right_turn+obj.get_rate(x,y,time-obj.turn_cost_right)*(obj.turn_cost_right-1);
            end
            straight=[x-1, y];
            left_turn=[x, y+1];
            right_turn=[x,y-1];
        elseif direction==1 % up
            profit_straight=obj.dp_rec(x, y-1, direction, time-1);
            if profit_straight>0
                profit_straight=profit_straight+(obj.visited_cells_matrix_2(x,y-1,direction+1, time-1+1, visited_index)==0)...
                    *(obj.sensing_matrix_2(x,y)==1)*obj.mean_rate;
            end
            %checking new cell on the old visited_cell_matrix
            profit_left_turn=obj.dp_rec(x-1, y, direction_left_turn, time-obj.turn_cost_left);
            if profit_left_turn>0
                profit_left_turn=profit_left_turn+(obj.visited_cells_matrix_2(x-1,y,direction_left_turn+1, time-obj.turn_cost_left+1, visited_index)==0)...
                    *(obj.sensing_matrix_2(x,y)==1)*obj.mean_rate;
                for ii =1:obj.turn_cost_left-1
                    profit_left_turn=profit_left_turn+obj.get_rate(x,y,time-ii);
                end
                % profit_left_turn=profit_left_turn+obj.get_rate(x,y,time-obj.turn_cost_left)*(obj.turn_cost_left-1);
            end
            profit_right_turn=obj.dp_rec(x+1, y, direction_right_turn, time-obj.turn_cost_right);
            if profit_right_turn>0
                profit_right_turn=profit_right_turn+(obj.visited_cells_matrix_2(x+1,y,direction_right_turn+1, time-obj.turn_cost_right+1, visited_index)==0)...
                    *(obj.sensing_matrix_2(x,y)==1)*obj.mean_rate;
                for ii =1:obj.turn_cost_right-1
                    profit_right_turn=profit_right_turn+obj.get_rate(x,y,time-ii);
                end
                % profit_right_turn=profit_right_turn+obj.get_rate(x,y,time-obj.turn_cost_right)*(obj.turn_cost_right-1);
            end
            straight=[x, y-1];
            left_turn=[x-1, y];
            right_turn=[x+1,y];
        elseif direction==2 % left
            profit_straight=obj.dp_rec(x+1, y, direction, time-1);
            if profit_straight>0
                profit_straight=profit_straight+(obj.visited_cells_matrix(x+1,y,direction+1, time-1+1, visited_index)==0)...
                    *(obj.sensing_matrix(x,y)==1)*obj.mean_rate;
            end
            
            profit_left_turn=obj.dp_rec(x, y-1, direction_left_turn, time-obj.turn_cost_left);
            if profit_left_turn>0
                profit_left_turn=profit_left_turn+(obj.visited_cells_matrix(x,y-1,direction_left_turn+1, time-obj.turn_cost_left+1,visited_index)==0)...
                    *(obj.sensing_matrix(x,y)==1)*obj.mean_rate;
                for ii =1:obj.turn_cost_left-1
                    profit_left_turn=profit_left_turn+obj.get_rate(x,y,time-ii);
                end
                % profit_left_turn=profit_left_turn+obj.get_rate(x,y,time-obj.turn_cost_left)*(obj.turn_cost_left-1);
            end
            profit_right_turn=obj.dp_rec(x, y+1, direction_right_turn, time-obj.turn_cost_right);
            if profit_right_turn>0
                profit_right_turn=profit_right_turn+(obj.visited_cells_matrix(x,y+1,direction_right_turn+1, time-obj.turn_cost_right+1, visited_index)==0)...
                    *(obj.sensing_matrix(x,y)==1)*obj.mean_rate;
                for ii =1:obj.turn_cost_right-1
                    profit_right_turn=profit_right_turn+obj.get_rate(x,y,time-ii);
                end
                % profit_right_turn=profit_right_turn+obj.get_rate(x,y,time-obj.turn_cost_right)*(obj.turn_cost_right-1);
            end
            straight=[x+1, y];
            left_turn=[x, y-1];
            right_turn=[x,y+1];
        elseif direction==3 % down
            profit_straight=obj.dp_rec(x, y+1, direction, time-1);
            if profit_straight>0
                profit_straight=profit_straight+(obj.visited_cells_matrix_2(x,y+1,direction+1, time-1+1, visited_index)==0)...
                    *(obj.sensing_matrix_2(x,y)==1)*obj.mean_rate;
            end
            profit_left_turn=obj.dp_rec(x+1, y, direction_left_turn, time-obj.turn_cost_left);
            if profit_left_turn>0
                profit_left_turn=profit_left_turn+(obj.visited_cells_matrix_2(x+1,y,direction_left_turn+1, time-obj.turn_cost_left+1, visited_index)==0)...
                    *(obj.sensing_matrix_2(x,y)==1)*obj.mean_rate;
                for ii =1:obj.turn_cost_left-1
                    profit_left_turn=profit_left_turn+obj.get_rate(x,y,time-ii);
                end
                % profit_left_turn=profit_left_turn+obj.get_rate(x,y,time-obj.turn_cost_left)*(obj.turn_cost_left-1);
            end
            profit_right_turn=obj.dp_rec(x-1, y, direction_right_turn, time-obj.turn_cost_right);
            if profit_right_turn>0
                profit_right_turn=profit_right_turn+(obj.visited_cells_matrix_2(x-1,y,direction_right_turn+1, time-obj.turn_cost_right+1, visited_index)==0)...
                    *(obj.sensing_matrix_2(x,y)==1)*obj.mean_rate;
                for ii =1:obj.turn_cost_right-1
                    profit_right_turn=profit_right_turn+obj.get_rate(x,y,time-ii);
                end
                % profit_right_turn=profit_right_turn+obj.get_rate(x,y,time-obj.turn_cost_right)*(obj.turn_cost_right-1);
            end
            straight=[x, y+1];
            left_turn=[x+1, y];
            right_turn=[x-1,y];
        else
            disp('error')
        end
        profit_less_time=obj.dp_rec(x,y,direction, time-1);
        profit_walk=max([profit_straight, profit_left_turn, profit_right_turn]);
        % if profit_walk==profit_straight
        %     walk_time_parameter=time-1;
        % elseif profit_walk==profit_left_turn
        %     walk_time_parameter=time-obj.turn_cost_left;
        % elseif profit_walk==profit_right_turn
        %     walk_time_parameter=time-obj.turn_cost_right;
        % else
        %     disp('error in DP_class_channel profit_walk')
        % end
        % 
        profit=max([profit_walk+obj.get_rate(x,y,time)*(profit_walk~=0), profit_less_time]);
        % self=0;
        % if profit==profit_walk && profit~=0 && profit~=profit_less_time
        %     self=1;
        % end
        if profit==profit_less_time
            obj.last_step_matrix(x,y,direction+1, time+1,1)=x;
            obj.last_step_matrix(x,y,direction+1, time+1,2)=y;
            obj.last_step_matrix(x,y,direction+1, time+1, 3)=direction;
            obj.last_step_matrix(x,y,direction+1, time+1, 4)=time-1;
            obj.visited_cells_matrix(x,y,direction+1, time+1, :)=...
                    obj.visited_cells_matrix(x,y,direction+1, time-1+1, :);
            obj.visited_cells_matrix_2(x,y,direction+1, time+1, :)=...
                    obj.visited_cells_matrix_2(x,y,direction+1, time-1+1, :);
        % elseif profit==profit_walk+obj.get_rate(x,y,time-1) || profit==profit_walk+obj.get_rate(x,y,time-obj.turn_cost_right) || ...
        %         profit==profit_walk+obj.get_rate(x,y,time-obj.turn_cost_left)
        elseif profit==profit_walk+obj.get_rate(x,y,time)
            if profit_walk==profit_straight
                obj.last_step_matrix(x,y,direction+1, time+1, 1)=straight(1);
                obj.last_step_matrix(x,y,direction+1, time+1, 2)=straight(2);
                obj.last_step_matrix(x,y,direction+1, time+1, 3)=direction;
                obj.last_step_matrix(x,y,direction+1, time+1, 4)=time-1;
                obj.visited_cells_matrix(x,y,direction+1, time+1, :)=...
                    obj.visited_cells_matrix(straight(1),straight(2),direction+1, time-1+1, :);
                obj.visited_cells_matrix_2(x,y,direction+1, time+1, :)=...
                    obj.visited_cells_matrix_2(straight(1),straight(2),direction+1, time-1+1, :);
            elseif profit_walk==profit_left_turn
                obj.last_step_matrix(x,y,direction+1, time+1, 1)=left_turn(1);
                obj.last_step_matrix(x,y,direction+1, time+1, 2)=left_turn(2);
                obj.last_step_matrix(x,y,direction+1, time+1, 3)=direction_left_turn;
                obj.last_step_matrix(x,y,direction+1, time+1, 4)=time-obj.turn_cost_left;
                obj.visited_cells_matrix(x,y,direction+1, time+1, :)=...
                    obj.visited_cells_matrix(left_turn(1),left_turn(2),direction_left_turn+1, time-obj.turn_cost_left+1, :);
                obj.visited_cells_matrix_2(x,y,direction+1, time+1, :)=...
                    obj.visited_cells_matrix_2(left_turn(1),left_turn(2),direction_left_turn+1, time-obj.turn_cost_left+1, :);
            elseif profit_walk==profit_right_turn
                obj.last_step_matrix(x,y,direction+1, time+1, 1)=right_turn(1);
                obj.last_step_matrix(x,y,direction+1, time+1, 2)=right_turn(2);
                obj.last_step_matrix(x,y,direction+1, time+1, 3)=direction_right_turn;
                obj.last_step_matrix(x,y,direction+1, time+1, 4)=time-obj.turn_cost_right;
                obj.visited_cells_matrix(x,y,direction+1, time+1, :)=...
                    obj.visited_cells_matrix(right_turn(1),right_turn(2),direction_right_turn+1, time-obj.turn_cost_right+1, :);
                obj.visited_cells_matrix_2(x,y,direction+1, time+1, :)=...
                    obj.visited_cells_matrix_2(right_turn(1),right_turn(2),direction_right_turn+1, time-obj.turn_cost_right+1, :);
            else
                    disp('error4')
            end

        else
            profit
            profit_walk
            profit_less_time
        end
        % profit=profit+self*obj.get_rate(x,y,time);
        if obj.obstacle_matrix(x,y)==1
            profit=profit*-1;
        end
        obj.dp_matrix(x,y,direction+1, time+1)=profit;
        % if obj.visited_cells_matrix(x,y,direction+1, time+1, visited_index)==0 && profit~=0
        %     profit=profit+obj.mean_rate;
        %     obj.visited_cells_matrix(x,y,direction+1, time+1, visited_index)=1;
        % end
    else
        profit=obj.dp_matrix(x,y,direction+1, time+1);
    end
    % adding the rate of this cell will be in main program
    % profit > 0 is gauranteed in the above
    if direction==0 || direction==2
        if obj.visited_cells_matrix(x,y,direction+1, time+1, visited_index)==0 && profit~=0
            % profit=profit+obj.mean_rate;
            obj.visited_cells_matrix(x,y,direction+1, time+1, visited_index)=1;
            if profit~=profit_walk+obj.get_rate(x,y,time)
                x
                y
                time
                direction
            end
        end
    else
        if obj.visited_cells_matrix_2(x,y,direction+1, time+1, visited_index)==0 && profit~=0
            % profit=profit+obj.mean_rate;
            obj.visited_cells_matrix_2(x,y,direction+1, time+1, visited_index)=1;
            if profit~=profit_walk+obj.get_rate(x,y,time)
                x
                y
                time
                direction
            end
        end
    end
    
end