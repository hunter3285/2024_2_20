function initialize_DP_comm_Solver(obj)
d=DP_Solver(obj);
d.sensing_matrix=zeros(obj.N_cell_x, obj.N_cell_y);
d.sensing_matrix_2=zeros(obj.N_cell_x, obj.N_cell_y);
obj.dp_solver_communication=d;
obj.N_Solver=obj.N_Solver+1;
end