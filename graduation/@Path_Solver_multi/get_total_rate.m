function rate=get_total_rate(obj)
rate=0;

N_cell_x=       obj.N_cell_x;
N_cell_y=       obj.N_cell_y;
start=          obj.start;
mean_rate=      obj.mean_rate;
fixed_sensing_matrix=obj.fixed_sensing_matrix;
fixed_sensing_matrix_2=obj.fixed_sensing_matrix_2;
UAVs_step_with_time=obj.UAVs_step_with_time;
visited_matrix=zeros(N_cell_x, N_cell_y);
visited_matrix_2=zeros(N_cell_x, N_cell_y);
N_UAV=size(UAVs_step_with_time, 1)/2;
rate_vec=zeros(1, N_UAV);


for ii=1:N_UAV  
    all_step=obj.eliminate_same_steps(UAVs_step_with_time(ii*2-1:ii*2, :));
    Solver_inst=obj.Solver_row(ii);
    if ~isequal(all_step(:,1), start)
        continue
    end
    [all_step_with_time, last_step_turn, ~]=Solver_inst.StepWithTimeSlot();
    if ~isequal(all_step_with_time, UAVs_step_with_time(ii*2-1:ii*2, :))
        disp('error in get_total_rate UAVs_step_with_time')
    end
    gained_rate=Solver_inst.get_correct_rate();
    rate=rate+gained_rate;
    rate_vec(ii)=rate;
    if size(all_step,2)<=1
        continue;
    end
    % for counting n_grid, can't directly use count_n_grid
    % because it depends on the sensing_matrix (and sensing_matrix_2) of each UAV_Solver
    % but now all UAV need to share a same sensing_matrix (and sensing_matrix_2) together
    for jj=1:size(all_step,2)-1
        x=all_step(1,jj);
        y=all_step(2,jj);
        x_next=all_step(1,jj+1);
        y_next=all_step(2,jj+1);
        if x_next==0 && y_next==0
            if direction==0||direction==2
                visited_matrix(x,y)=1;
            else
                visited_matrix_2(x,y)=1;
            end
            break;
        end
        if x_next-x==1 && y_next-y==0
            direction=0;
        elseif x_next-x==-1 && y_next-y==0
            direction=2;
        elseif x_next-x==0 && y_next-y==1
            direction=1;
        elseif x_next-x==0 && y_next-y==-1
            direction=3;
        else
            disp('error in get_total_rate')
        end
        if direction==0||direction==2
            visited_matrix(x,y)=1;
        else
            visited_matrix_2(x,y)=1;
        end
    end
    x=x_next;
    y=y_next;
    if x==0 ||y==0
        continue;
    end
    if last_step_turn
        direction=mod(direction-1,4); %assume turn right, but for choosing visited_matrix, it doesn't matter
    end
    if direction==0||direction==2
        visited_matrix(x,y)=1;
    else
        visited_matrix_2(x,y)=1;
    end
end
n_grid_total=sum(visited_matrix_2.*fixed_sensing_matrix_2, 'all')+sum(visited_matrix.*fixed_sensing_matrix, 'all');
rate=rate+n_grid_total*mean_rate;
end