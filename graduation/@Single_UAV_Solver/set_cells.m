function set_cells(obj, cell_matrix)
N_cell_x=obj.N_cell_x;
N_cell_y=obj.N_cell_x;
coef_cell_matrix(N_cell_x, N_cell_y)=coef_array_cell;
for ii=1:N_cell_x
    for jj=1:N_cell_y
        coef_cell_matrix(ii,jj).coef_array=...
            coef_array(1:cell_matrix(ii,jj).N_user);
    end
end

N_users=zeros(N_cell_x, N_cell_y);
for ii=1:N_cell_x
    for jj=1:N_cell_y
        N_users(ii, jj)=cell_matrix(ii,jj).N_users;
    end
end
total_users=sum(N_users, 'all');


all_rate_matrix=zeros(N_cell_x, N_cell_y);
for ii=1:N_cell_x
    for jj=1:N_cell_y
        all_rate_matrix(ii,jj)=cell_matrix(ii,jj).sum_rate;
    end
end






obj.cell_matrix=cell_matrix;
obj.coef_cell_matrix=coef_cell_matrix;
obj.total_users=total_users;
obj.N_user_matrix=N_users;
obj.all_rate_matrix=all_rate_matrix;
end