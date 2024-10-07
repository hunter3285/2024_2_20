function initialize_DP_sens_multi_Solver(obj)
    d=DP_Solver_multi(obj);
    d.mean_rate=1e9;
    obj.DP_sens_multi_Solver=d;
    obj.N_Solver=obj.N_Solver+1;
end