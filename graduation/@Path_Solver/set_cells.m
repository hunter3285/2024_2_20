function set_cells(obj, UAV_Solver_instance)
%called after set cell in UAV_Solver's
obj.coef_vec_cell_matrix=UAV_Solver_instance.coef_vec_cell_matrix;
obj.N_user_matrix=UAV_Solver_instance.N_user_matrix;
obj.mean_rate=UAV_Solver_instance.mean_rate;
end