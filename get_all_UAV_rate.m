function [rate, rate_vec, n_grid_total]=get_all_UAV_rate(UAVs_step_with_time, UAVs_power_vec, cell_matrix)
rate=0;n_grid=0;
load("cell_matrix.mat", 'N_cell_x', 'N_cell_y', 'mean_rate', 'start')
visited_matrix=zeros(N_cell_x, N_cell_y);
visited_matrix_2=zeros(N_cell_x, N_cell_y);
N_UAV=size(UAVs_step_with_time, 1)/2;
rate_vec=zeros(1, N_UAV);
for ii=1:N_UAV  
    all_step=eliminate_same_steps(UAVs_step_with_time(ii*2-1:ii*2, :));
    power_vec=UAVs_power_vec(ii,:);
    if ~isequal(all_step(:,1), start)
        continue
    end
    [~, last_step_turn, ~]=StepWithTimeSlot(all_step);
    gained_rate=get_correct_rate(all_step, power_vec, cell_matrix);
    rate=rate+gained_rate;
    rate_vec(ii)=rate;
    if size(all_step,2)<=1
        n_grid=n_grid+1;
        continue;
    end
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
            disp('error in count_n_gird')
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
n_grid_total=sum(visited_matrix_2, 'all')+sum(visited_matrix, 'all');
rate=rate+n_grid_total*mean_rate;