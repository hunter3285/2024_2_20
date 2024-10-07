function initialize_DP_comm_multi_Solver(obj)
    d=DP_Solver_multi(obj);
    for ii=1:obj.N_UAV
        d.Solver_row(ii).sensing_matrix=zeros(obj.N_cell_x, obj.N_cell_y);
        d.Solver_row(ii).sensing_matrix_2=zeros(obj.N_cell_x, obj.N_cell_y);
    end
    % 因為在計算最終結果的時候會用到Path_Solver_multi類別的get_total_rate，
    % 我們不要直接改DP_Solver_multi(也是一個Path_Solver_multi)的fixed_sensing_matrix
    % get_total_rate function會用到的fixed_sensing_matrix
    obj.DP_comm_multi_Solver=d;
    obj.N_Solver=obj.N_Solver+1;
end