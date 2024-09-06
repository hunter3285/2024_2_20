classdef DP_class_channel < handle
    properties
        all_rate_matrix;
        mean_rate;
        start;
        turn_cost_left;
        turn_cost_right;
        N_cell_x;
        N_cell_y;
        time_slot_max;
        dp_matrix;
        last_step_matrix;
        visited_cells_matrix; % see initialization, last index to store visited cells
        visited_cells_matrix_2;
        sensing_matrix;
        obstacle_matrix;
        channel_coef_matrix;
        power_vec;
        noise_variance;
        N_user_matrix;
        sensing_matrix_2;
    end
    methods
        function obj=DP_class_channel(sensing_matrix, sensing_matrix_2, obstacle_matrix, power_vec)
            load("cell_matrix.mat", "all_rate_matrix", 'start', 'turn_cost_right', 'turn_cost_left', 'time_slot_max', 'coef_cell_matrix', 'N_user_matrix', 'mean_rate');
            load('SARparams.mat', 'noise_variance')
            obj.noise_variance=noise_variance;
            obj.all_rate_matrix=all_rate_matrix;
            obj.N_user_matrix=N_user_matrix;
                
            obj.mean_rate=mean_rate;%%%%%%%%%%%%%%%%%%%%
            obj.start=start;
            obj.turn_cost_right=turn_cost_right;
            obj.turn_cost_left=turn_cost_left;
            obj.N_cell_x=size(all_rate_matrix,1);
            obj.N_cell_y=size(all_rate_matrix,2);
            N_users_max=max(N_user_matrix,[],'all');
            obj.channel_coef_matrix=zeros(obj.N_cell_x, obj.N_cell_y, N_users_max);
            for ii=1:obj.N_cell_x
                for jj=1:obj.N_cell_y
                    a=length(coef_cell_matrix(ii,jj).coef_array);
                    obj.channel_coef_matrix(ii,jj,1:a)=coef_cell_matrix(ii,jj).coef_array;
                end
            end

            obj.time_slot_max=time_slot_max;
            obj.set_power_vec(power_vec);
            obj.dp_matrix=-1*ones(obj.N_cell_x, obj.N_cell_y, 4, time_slot_max);
            obj.last_step_matrix=-1*ones(obj.N_cell_x, obj.N_cell_y, 4, time_slot_max+1,4);
            obj.visited_cells_matrix=zeros(obj.N_cell_x, obj.N_cell_y, 4, time_slot_max+1, obj.N_cell_x*obj.N_cell_y);
            obj.visited_cells_matrix_2=zeros(obj.N_cell_x, obj.N_cell_y, 4, time_slot_max+1, obj.N_cell_x*obj.N_cell_y);
            obj.sensing_matrix=sensing_matrix;
            obj.sensing_matrix_2=sensing_matrix_2;
            if sum(sensing_matrix+sensing_matrix_2, 'all')==0
                obj.all_rate_matrix(start(1), start(2))=obj.all_rate_matrix(start(1), start(2))+1e-6; % in case that rate is also zero at start
            end
            obj.obstacle_matrix=obstacle_matrix;
            % obj.cells_for_sensing(start(1), start(2))=0;
        end
        function clear(obj)
            obj.dp_matrix=-1*ones(obj.N_cell_x, obj.N_cell_y, 4, obj.time_slot_max+1);
            obj.last_step_matrix=-1*ones(obj.N_cell_x, obj.N_cell_y, 4, obj.time_slot_max+1,4);
            obj.visited_cells_matrix=zeros(obj.N_cell_x, obj.N_cell_y, 4, obj.time_slot_max+1, obj.N_cell_x*obj.N_cell_y);
            obj.visited_cells_matrix_2=zeros(obj.N_cell_x, obj.N_cell_y, 4, obj.time_slot_max+1, obj.N_cell_x*obj.N_cell_y);
        end
        function set_power_vec(obj, power_vec)
            obj.power_vec=power_vec;
            if length(power_vec)~=obj.time_slot_max
                disp('error in DP_class_channel')
                obj.power_vec=[power_vec;zeros(obj.time_slot_max-length(power_vec),1)];
            end
        end
        function set_sensing_matrices(obj, sensing_matrix_in, sensign_matrix_2_in)
            obj.sensing_matrix=sensing_matrix_in;
            obj.sensing_matrix_2=sensign_matrix_2_in;
            if ~isequal(size(sensing_matrix_in), [obj.N_cell_x, obj.N_cell_y])|| ~isequal(size(sensign_matrix_2_in), [obj.N_cell_x, obj.N_cell_y])
                disp('error in set sensing matrices in DP_class_channel')
            end

        end
        function rate=get_rate(obj, x,y, time)
            if time<0
                rate=0;
                return;
            end
            p=obj.power_vec(time+1);
            channel_vec=obj.channel_coef_matrix(x,y,:);
            if isempty(channel_vec)
                rate=0;
                return
            end
            channel_vec=reshape(channel_vec,length(channel_vec),1);
            signal_vec=p*channel_vec;

            rate=sum(log2(1+signal_vec/obj.noise_variance));
            if obj.N_user_matrix(x,y)~=0
                rate=rate/obj.N_user_matrix(x,y);
            end
            % [x,y,rate]
        end
        function [max_profit, max_index]=dp_main(obj)

            for ii=1:obj.N_cell_x
                for jj=1:obj.N_cell_y
                    for time_slot=0:obj.time_slot_max-1
                        for direction=0:3
                            obj.dp_matrix(ii,jj,direction+1,time_slot+1)=obj.dp_rec(ii,jj,direction,time_slot);
                        end
                    end
                end
            end
            [max_profit,max_index]=max(obj.dp_matrix(:,:,:,time_slot+1), [], "all");
        end
        
        %% dp function
        function [ profit]=dp_rec(obj, x, y, direction, time) % time=0:obj.time_slot_max-1
%             x
%             y
%             direction
%             time
            if ~check_direction([x;y], obj.N_cell_x, obj.N_cell_y)
                profit=0;
                return;
            end
            if time<0
                profit=0;
                return;
            end
            % when using direction as index of matrix, +1 to become 1:4
            visited_index=(y-1)*10+x;
            if obj.dp_matrix(x,y,direction+1, time+1)==-1 % not yet calculated
                if time==0
                    if x==obj.start(1) && y==obj.start(2) %  time=0 at start point
                        profit=obj.get_rate(x,y,time);
                        if obj.sensing_matrix(x, y)==1 && (direction==0||direction==2)
%                             if (direction==0||direction==2) && obj.visited_cells_matrix(x,y,direction+1, time+1, visited_index)==0
                            profit=profit+obj.mean_rate;
%                             elseif (direction==1||direction==3) && obj.visited_cells_matrix_2(x,y,direction+1, time+1, visited_index)==0
%                                 profit=profit+obj.mean_rate;
%                             end
                        end
                        if obj.sensing_matrix_2(x, y)==1 && (direction==1||direction==3)
%                             if (direction==0||direction==2) && obj.visited_cells_matrix(x,y,direction+1, time+1, visited_index)==0
                            profit=profit+obj.mean_rate;
%                             elseif (direction==1||direction==3) && obj.visited_cells_matrix_2(x,y,direction+1, time+1, visited_index)==0
%                                 profit=profit+obj.mean_rate;
%                             end
                        end
                        if sum(obj.sensing_matrix+obj.sensing_matrix_2,'all')==0
                            profit=profit+1e-6; % in case the rate is zero
                        end
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


    end
end