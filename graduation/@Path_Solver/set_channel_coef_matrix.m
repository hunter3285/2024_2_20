function set_channel_coef_matrix(obj, UAV_Solver_instance)
N_users_max=max(obj.N_user_matrix,[],'all');
coef_vec_cell_matrix=UAV_Solver_instance.coef_vec_cell_matrix;
obj.coef_vec_cell_matrix=zeros(obj.N_cell_x, obj.N_cell_y, N_users_max);
for ii=1:obj.N_cell_x
    for jj=1:obj.N_cell_y
        a=length(coef_vec_cell_matrix(ii,jj).coef_array);
        obj.coef_vec_cell_matrix(ii,jj,1:a)=coef_vec_cell_matrix(ii,jj).coef_array;
    end
end
end