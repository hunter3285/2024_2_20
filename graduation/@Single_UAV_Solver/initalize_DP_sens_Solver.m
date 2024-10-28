function initalize_DP_sens_Solver(obj)
obj.dp_solver_sensing=DP_Solver(obj);
obj.N_Solver=obj.N_Solver+1;
obj.dp_solver_sensing.mean_rate=1e6;
max_user=max(obj.N_user_matrix, [],'all');
for ii=1:obj.N_cell_x
    for jj=1:obj.N_cell_y
        obj.dp_solver_sensing.coef_vec_cell_matrix(ii, jj, :)=zeros(max_user,1);
    end
end
end