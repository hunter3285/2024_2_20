function  [total_visited, total_visited_2]=get_total_visited(target_UAV_idx, UAVs_step_with_time, last_step_turn_vec, last_turn_right_or_left_vec)
N_UAV=size(UAVs_step_with_time,1)/2;
load('cell_matrix.mat','N_cell_x','N_cell_y','start', 'turn_cost_right', 'turn_cost_left')
total_visited=zeros(N_cell_x, N_cell_y);
total_visited_2=zeros(N_cell_x, N_cell_y);
for ii=1:N_UAV
    check=0;
    if ii==target_UAV_idx
        continue;
    end
    last_step_turn=last_step_turn_vec(ii);
    last_turn_right_or_left=last_turn_right_or_left_vec(ii);
    if last_turn_right_or_left==2
        turn_cost_temp=turn_cost_left;
    elseif last_turn_right_or_left==1
        turn_cost_temp=turn_cost_right;
    else
        turn_cost_temp=0;
    end
    all_step_with_time=UAVs_step_with_time(ii*2-1:ii*2, :);
    last_x=start(1);
    last_y=start(2);
    for jj=2:size(all_step_with_time,2)
        x=all_step_with_time(1,jj);
        y=all_step_with_time(2,jj);
        if x==last_x && y==last_y
            continue;
        end
        if x==0 && y==0
            break;
        end
        if x-last_x==1 && y-last_y==0
            direction=0;
        elseif x-last_x==-1 && y-last_y==0
            direction=2;
        elseif x-last_x==0 && y-last_y==1
            direction=1;
        elseif x-last_x==0 && y-last_y==-1
            direction=3;
        else
            disp('error in get_total_visited')
        end
        if last_step_turn && jj==size(all_step_with_time,2)-turn_cost_temp+1
            check=1;
            if last_turn_right_or_left==0
                direction=mod(direction+1, 4);
            else
                direction=mod(direction-1, 4);
            end
        end
        if direction==0||direction==2
            total_visited(x,y)=1;
        else
            total_visited_2(x,y)=1;
        end
        if jj==2
            if direction==0||direction==2
                total_visited(last_x,last_y)=1;
            else
                total_visited_2(last_x,last_y)=1;
            end
        end
        last_x=x;
        last_y=y;
        
    end
    if check==0 && last_step_turn==1
        disp('error in get_total_visited')
    end


end