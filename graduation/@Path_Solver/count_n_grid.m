function n_grid=count_n_grid(obj)
all_step_dp=obj.all_step;
N_cell_x=obj.N_cell_x;
N_cell_y=obj.N_cell_y;
% start=obj.start;
sensing_matrix=obj.sensing_matrix;
sensing_matrix_2=obj.sensing_matrix_2;
last_step_turn=obj.last_step_turn;

visited_matrix=zeros(N_cell_x, N_cell_y);
visited_matrix_2=zeros(N_cell_x, N_cell_y);
if size(all_step_dp,2)<=1
    n_grid=1;
    return;
end
for ii=1:size(all_step_dp,2)-1
    x=all_step_dp(1,ii);
    y=all_step_dp(2,ii);
    x_next=all_step_dp(1,ii+1);
    y_next=all_step_dp(2,ii+1);
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
if last_step_turn
    direction=mod(direction-1,4); %assume turn right, but for choosing visited_matrix, it doesn't matter
end
if direction==0||direction==2
    visited_matrix(x,y)=1;
else
    visited_matrix_2(x,y)=1;
end

% visited_matrix
% visited_matrix_2
% sensing_matrix
% sensing_matrix_2
n_grid=sum(visited_matrix_2.*sensing_matrix_2, 'all')+sum(visited_matrix.*sensing_matrix,'all');

