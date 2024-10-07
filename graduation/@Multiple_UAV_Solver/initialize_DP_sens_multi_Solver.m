function initialize_DP_sens_multi_Solver(obj)
    d=DP_Solver_multi(obj);
    for ii=1:length(d.Solver_row)
        d.Solver_row(ii).mean_rate=1e9;
    end
    % 因為在計算最終結果的時候會用到Path_Solver_multi類別的get_total_rate，
    % 我們不要直接改DP_Solver_multi(也是一個Path_Solver_multi)的mean_rate
    % get_total_rate function會用到mean_rate
    obj.DP_sens_multi_Solver=d;
    obj.N_Solver=obj.N_Solver+1;
end